package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.*;
import dk.camelot64.kickc.model.types.SymbolType;
import dk.camelot64.kickc.model.types.SymbolTypeArray;
import dk.camelot64.kickc.model.values.*;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Compiler Pass that generates Single Static Assignment Form based on a Control Flow Graph.
 * <p>First versions all variable assignments, then versions all variable usages and introduces necessary Phi-functions,
 * <p>See https://en.wikipedia.org/wiki/Static_single_assignment_form
 */
public class Pass1GenerateSingleStaticAssignmentForm extends Pass1Base {

   public Pass1GenerateSingleStaticAssignmentForm(Program program) {
      super(program);
   }

   @Override
   public boolean step() {
      versionAllAssignments();
      versionAllUses();
      boolean done;
      do {
         if(getLog().isVerbosePass1CreateSsa()) {
            getLog().append("Completing Phi functions...");
            //getLog().append(getGraph().toString(getProgram()));
         }
         done = completePhiFunctions();
      } while(!done);
      return false;
   }

   /**
    * Version all non-versioned non-intermediary being assigned a value.
    */
   private void versionAllAssignments() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue statementLValue = (StatementLValue) statement;
               LValue lValue = statementLValue.getlValue();
               if(lValue instanceof VariableRef) {
                  versionAssignment((VariableRef) lValue, new ProgramValue.ProgramValueLValue(statementLValue), statementLValue.getSource());
               } else if(lValue instanceof ValueList) {
                  List<RValue> lValueList = ((ValueList) lValue).getList();
                  for(int i = 0; i < lValueList.size(); i++) {
                     LValue lVal = (LValue) lValueList.get(i);
                     if(lVal instanceof VariableRef) {
                        versionAssignment((VariableRef) lVal, new ProgramValue.ProgramValueListElement((ValueList) lValue, i), statementLValue.getSource());
                     }
                  }
               }
            }
         }
      }
   }

   /**
    * Version a single unversioned variable being assigned
    * @param lValueRef The variable  being assigned
    * @param programLValue Program Value usable for updating the variable
    * @param source The statement source - usable for error messages
    */
   private void versionAssignment(VariableRef lValueRef, ProgramValue programLValue, StatementSource source) {
      Collection<VariableRef> earlyIdentifiedConstants = getProgram().getEarlyIdentifiedConstants();
      Variable assignedVar = getScope().getVariable(lValueRef);
      if(assignedVar.isStoragePhiMaster()) {
         // Assignment to a non-versioned non-intermediary variable
         Variable assignedSymbol = assignedVar;
         Variable version;
         if(assignedSymbol.isDeclaredConstant() || earlyIdentifiedConstants.contains(assignedSymbol.getRef())) {
            Collection<Variable> versions = assignedVar.getScope().getVersions(assignedSymbol);
            if(versions.size() != 0) {
               throw new CompileError("Error! Constants can not be modified", source);
            }
            version = assignedSymbol.createVersion();
            version.setDeclaredConstant(true);
         } else {
            version = assignedSymbol.createVersion();
         }
         programLValue.set(version.getRef());
      }
   }

   /**
    * Version all uses of non-versioned non-intermediary variables
    */
   private void versionAllUses() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         // Newest version of variables in the block.
         Map<Variable, Variable> blockVersions = new LinkedHashMap<>();
         // New phi functions introduced in the block to create versions of variables.
         Map<Variable, Variable> blockNewPhis = new LinkedHashMap<>();
         ProgramValueIterator.execute(block, (programValue, currentStmt, stmtIt, currentBlock) -> {
            if(programValue instanceof ProgramValue.ProgramValueParamValue) {
               // Call parameter values should not be versioned
               return;
            }
            Value value = programValue.get();
            Variable version = findOrCreateVersion(value, blockVersions, blockNewPhis);
            if(version != null) {
               programValue.set(version.getRef());
            }
            // Update map of versions encountered in the block
            if(currentStmt instanceof StatementLValue && programValue instanceof ProgramValue.ProgramValueLValue) {
               StatementLValue statementLValue = (StatementLValue) currentStmt;
               LValue lValue = statementLValue.getlValue();
               if(lValue instanceof VariableRef) {
                  updateBlockVersions((VariableRef) lValue, blockVersions);
               } else if(lValue instanceof ValueList) {
                  List<RValue> lValueList = ((ValueList) lValue).getList();
                  for(RValue lValueElement : lValueList) {
                     if(lValueElement instanceof VariableRef) {
                        updateBlockVersions((VariableRef) lValueElement, blockVersions);
                     }
                  }
               }
            }
            // Examine if the assigned variable is an array with a fixed size
            if(currentStmt instanceof StatementAssignment) {
               LValue lValue = ((StatementAssignment) currentStmt).getlValue();
               if(lValue instanceof VariableRef) {
                  Variable assignedVar = Pass1GenerateSingleStaticAssignmentForm.this.getScope().getVariable((VariableRef) lValue);
                  SymbolType assignedVarType = assignedVar.getType();
                  if(assignedVarType instanceof SymbolTypeArray) {
                     SymbolTypeArray assignedArrayType = (SymbolTypeArray) assignedVarType;
                     RValue arraySize = assignedArrayType.getSize();
                     Variable vrs = findOrCreateVersion(arraySize, blockVersions, blockNewPhis);
                     if(vrs != null) {
                        assignedArrayType.setSize(vrs.getRef());
                     }
                  }
               }
            }
         });
         // Add new Phi functions to block
         for(Variable symbol : blockNewPhis.keySet()) {
            block.getPhiBlock().addPhiVariable(blockNewPhis.get(symbol).getRef());
         }
      }
   }

   private void updateBlockVersions(VariableRef lValue, Map<Variable, Variable> blockVersions) {
      VariableRef lValueRef = lValue;
      Variable variable = Pass1GenerateSingleStaticAssignmentForm.this.getScope().getVariable(lValueRef);
      if(variable.isStoragePhiVersion()) {
         blockVersions.put(variable.getVersionOf(), variable);
      }
   }

   /**
    * Find and return the latest version of an rValue (if it is a non-versioned symbol).
    * If a version is needed and no version is found a new version is created as a phi-function.
    *
    * @param rValue The rValue to examine
    * @param blockVersions The current version defined in the block for each symbol.
    * @param blockNewPhis New versions to be created as phi-functions. Modified if a new phi-function needs to be created.
    * @return Null if the rValue does not need versioning. The versioned symbol to use if it does.
    */
   private Variable findOrCreateVersion(
         Value rValue,
         Map<Variable, Variable> blockVersions,
         Map<Variable, Variable> blockNewPhis) {
      Collection<VariableRef> earlyIdentifiedConstants = getProgram().getEarlyIdentifiedConstants();
      Variable version = null;
      if(rValue instanceof VariableRef) {
         Variable rValueVar = getScope().getVariable((VariableRef) rValue);
         if(rValueVar.isStoragePhiMaster()) {
            // rValue needs versioning - look for version in statements
            Variable rSymbol = rValueVar;
            if(rSymbol.isDeclaredConstant() || earlyIdentifiedConstants.contains(rSymbol.getRef())) {
               // A constant - find the single created version
               Scope scope = rSymbol.getScope();
               Collection<Variable> versions = scope.getVersions(rSymbol);
               if(versions.size() != 1) {
                  throw new CompileError("Error! Constants must have exactly one version " + rSymbol);
               }
               return versions.iterator().next();
            } else {
               // A proper variable - find or create version
               version = blockVersions.get(rSymbol);
               if(version == null) {
                  // look for version in new phi functions
                  version = blockNewPhis.get(rSymbol);
               }
               if(version == null) {
                  // create a new phi function
                  version = rSymbol.createVersion();
                  blockNewPhis.put(rSymbol, version);
               }
            }
         }
      }
      return version;
   }

   /**
    * Look through all new phi-functions and fill out their parameters.
    *
    * @return true if all phis were completely filled out.
    * false if new phis were added, meaning another iteration is needed.
    */
   private boolean completePhiFunctions() {
      Map<LabelRef, Map<Variable, Variable>> newPhis = new LinkedHashMap<>();
      Map<LabelRef, Map<Variable, Variable>> symbolMap = buildSymbolMap();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {

            if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  if(phiVariable.isEmpty()) {
                     VariableRef phiLValVarRef = phiVariable.getVariable();
                     Variable versioned = getScope().getVariable(phiLValVarRef);
                     Variable unversioned = versioned.getVersionOf();
                     List<ControlFlowBlock> predecessors = getPhiPredecessors(block, getProgram());
                     for(ControlFlowBlock predecessor : predecessors) {
                        LabelRef predecessorLabel = predecessor.getLabel();
                        Map<Variable, Variable> predecessorMap = symbolMap.get(predecessorLabel);
                        Variable previousSymbol = null;
                        if(predecessorMap != null) {
                           previousSymbol = predecessorMap.get(unversioned);
                        }
                        if(previousSymbol == null) {
                           // No previous symbol found in predecessor block. Look in new phi functions.
                           Map<Variable, Variable> predecessorNewPhis = newPhis.get(predecessorLabel);
                           if(predecessorNewPhis == null) {
                              predecessorNewPhis = new LinkedHashMap<>();
                              newPhis.put(predecessorLabel, predecessorNewPhis);
                           }
                           previousSymbol = predecessorNewPhis.get(unversioned);
                           if(previousSymbol == null) {
                              // No previous symbol found in predecessor block. Add a new phi function to the predecessor.
                              previousSymbol = unversioned.createVersion();
                              predecessorNewPhis.put(unversioned, previousSymbol);
                           }
                        }
                        phiVariable.setrValue(predecessorLabel, previousSymbol.getRef());
                     }
                  }
               }
            }
         }
      }
      // Ads new phi functions to blocks
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         Map<Variable, Variable> blockNewPhis = newPhis.get(block.getLabel());
         if(blockNewPhis != null) {
            for(Variable symbol : blockNewPhis.keySet()) {
               StatementPhiBlock phiBlock = block.getPhiBlock();
               Variable variable = blockNewPhis.get(symbol);
               phiBlock.addPhiVariable(variable.getRef());
            }
         }
      }
      return (newPhis.size() == 0);
   }

   /**
    * Get all predecessors for a control flow block.
    * If the block is the start of an interrupt the @begin is included as a predecessor.
    *
    * @param block The block to examine
    * @return All predecessor blocks
    */
   public static List<ControlFlowBlock> getPhiPredecessors(ControlFlowBlock block, Program program) {
      List<ControlFlowBlock> predecessors = program.getGraph().getPredecessors(block);
      Symbol symbol = program.getScope().getSymbol(block.getLabel());
      if(symbol instanceof Procedure) {
         Procedure procedure = (Procedure) symbol;
         if(procedure.getInterruptType() != null || Pass2ConstantIdentification.isAddressOfUsed(procedure.getRef(), program)) {
            // Find all root-level predecessors to the main block
            ControlFlowBlock mainBlock = program.getGraph().getBlock(new LabelRef(SymbolRef.MAIN_PROC_NAME));
            List<ControlFlowBlock> mainPredecessors = program.getGraph().getPredecessors(mainBlock);
            for(ControlFlowBlock mainPredecessor : mainPredecessors) {
               if(mainPredecessor.getScope().equals(ScopeRef.ROOT)) {
                  predecessors.add(mainPredecessor);
               }
            }
         }
      }
      return predecessors;
   }

   /**
    * Builds a map of all which versions each symbol has in each block.
    * Maps Control Flow Block Label -> ( Unversioned Symbol -> Versioned Symbol) for all relevant symbols.
    */
   private Map<LabelRef, Map<Variable, Variable>> buildSymbolMap() {
      Map<LabelRef, Map<Variable, Variable>> symbolMap = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               addSymbolToMap(assignment.getlValue(), block, symbolMap);
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  addSymbolToMap(phiVariable.getVariable(), block, symbolMap);
               }
            }
         }
      }
      return symbolMap;
   }

   private void addSymbolToMap(LValue lValue, ControlFlowBlock block, Map<LabelRef, Map<Variable, Variable>> symbolMap) {
      if(lValue instanceof VariableRef) {
         Variable lValueVar = getScope().getVariable((VariableRef) lValue);
         if(lValueVar.isStoragePhiVersion()) {
            Variable versioned = lValueVar;
            LabelRef label = block.getLabel();
            Variable unversioned = versioned.getVersionOf();
            Map<Variable, Variable> blockMap = symbolMap.get(label);
            if(blockMap == null) {
               blockMap = new LinkedHashMap<>();
               symbolMap.put(label, blockMap);
            }
            blockMap.put(unversioned, versioned);
         }
      } else if(lValue instanceof ValueList) {
         for(RValue lValueElement : ((ValueList) lValue).getList()) {
            addSymbolToMap((LValue) lValueElement, block, symbolMap);
         }

      }
   }
}
