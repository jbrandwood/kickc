package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.model.CompileError;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAssignment;
import dk.camelot64.kickc.model.statements.StatementLValue;
import dk.camelot64.kickc.model.statements.StatementPhiBlock;
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
         }
         done = completePhiFunctions();
         //log.append(this.controlFlowGraph.toString(symbols));
      } while(!done);
      return false;
   }

   /**
    * Version all non-versioned non-intermediary being assigned a value.
    */
   private void versionAllAssignments() {
      Collection<VariableRef> earlyIdentifiedConstants = getProgram().getEarlyIdentifiedConstants();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue statementLValue = (StatementLValue) statement;
               dk.camelot64.kickc.model.values.LValue lValue = statementLValue.getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef lValueRef = (VariableRef) lValue;
                  Variable assignedVar = getScope().getVariable(lValueRef);
                  if(assignedVar instanceof VariableUnversioned) {
                     // Assignment to a non-versioned non-intermediary variable
                     VariableUnversioned assignedSymbol = (VariableUnversioned) assignedVar;
                     VariableVersion version;
                     if(assignedSymbol.isDeclaredConstant() || earlyIdentifiedConstants.contains(assignedSymbol.getRef())) {
                        Collection<VariableVersion> versions = assignedVar.getScope().getVersions(assignedSymbol);
                        if(versions.size() != 0) {
                           throw new CompileError("Error! Constants can not be modified " + statement, statement.getSource());
                        }
                        version = assignedSymbol.createVersion();
                        version.setDeclaredConstant(true);
                     } else {
                        version = assignedSymbol.createVersion();
                     }
                     statementLValue.setlValue(version.getRef());
                  }
               }
            }
         }
      }
   }

   /**
    * Version all uses of non-versioned non-intermediary variables
    */
   private void versionAllUses() {
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         // Newest version of variables in the block.
         Map<VariableUnversioned, VariableVersion> blockVersions = new LinkedHashMap<>();
         // New phi functions introduced in the block to create versions of variables.
         Map<VariableUnversioned, VariableVersion> blockNewPhis = new LinkedHashMap<>();
         ProgramValueIterator.execute(block, (programValue, currentStmt, stmtIt, currentBlock) -> {
            Value value = programValue.get();
            VariableVersion version = findOrCreateVersion(value, blockVersions, blockNewPhis);
            if(version != null) {
               programValue.set(version.getRef());
            }
            // Update map of versions encountered in the block
            if(currentStmt instanceof StatementAssignment && programValue instanceof ProgramValue.LValue) {
               StatementAssignment assignment = (StatementAssignment) currentStmt;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof VariableRef) {
                  VariableRef lValueRef = (VariableRef) lValue;
                  Variable variable = Pass1GenerateSingleStaticAssignmentForm.this.getScope().getVariable(lValueRef);
                  if(variable instanceof VariableVersion) {
                     VariableVersion versioned = (VariableVersion) variable;
                     blockVersions.put(versioned.getVersionOf(), versioned);
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
                     VariableVersion vrs = findOrCreateVersion(arraySize, blockVersions, blockNewPhis);
                     if(vrs != null) {
                        assignedArrayType.setSize(vrs.getRef());
                     }
                  }
               }
            }
         });
         // Add new Phi functions to block
         for(VariableUnversioned symbol : blockNewPhis.keySet()) {
            block.getPhiBlock().addPhiVariable(blockNewPhis.get(symbol).getRef());
         }
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
   private VariableVersion findOrCreateVersion(
         Value rValue,
         Map<VariableUnversioned, VariableVersion> blockVersions,
         Map<VariableUnversioned, VariableVersion> blockNewPhis) {
      Collection<VariableRef> earlyIdentifiedConstants = getProgram().getEarlyIdentifiedConstants();
      VariableVersion version = null;
      if(rValue instanceof VariableRef) {
         Variable rValueVar = getScope().getVariable((VariableRef) rValue);
         if(rValueVar instanceof VariableUnversioned) {
            // rValue needs versioning - look for version in statements
            VariableUnversioned rSymbol = (VariableUnversioned) rValueVar;
            if(rSymbol.isDeclaredConstant() || earlyIdentifiedConstants.contains(rSymbol.getRef())) {
               // A constant - find the single created version
               Scope scope = rSymbol.getScope();
               Collection<VariableVersion> versions = scope.getVersions(rSymbol);
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
      Map<LabelRef, Map<VariableUnversioned, VariableVersion>> newPhis = new LinkedHashMap<>();
      Map<LabelRef, Map<VariableUnversioned, VariableVersion>> symbolMap = buildSymbolMap();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {

            if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  if(phiVariable.isEmpty()) {
                     VariableRef phiLValVarRef = phiVariable.getVariable();
                     VariableVersion versioned = (VariableVersion) getScope().getVariable(phiLValVarRef);
                     VariableUnversioned unversioned = versioned.getVersionOf();
                     List<ControlFlowBlock> predecessors = getPredecessors(block);
                     for(ControlFlowBlock predecessor : predecessors) {
                        LabelRef predecessorLabel = predecessor.getLabel();
                        Map<VariableUnversioned, VariableVersion> predecessorMap = symbolMap.get(predecessorLabel);
                        VariableVersion previousSymbol = null;
                        if(predecessorMap != null) {
                           previousSymbol = predecessorMap.get(unversioned);
                        }
                        if(previousSymbol == null) {
                           // No previous symbol found in predecessor block. Look in new phi functions.
                           Map<VariableUnversioned, VariableVersion> predecessorNewPhis = newPhis.get(predecessorLabel);
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
         Map<VariableUnversioned, VariableVersion> blockNewPhis = newPhis.get(block.getLabel());
         if(blockNewPhis != null) {
            for(VariableUnversioned symbol : blockNewPhis.keySet()) {
               StatementPhiBlock phiBlock = block.getPhiBlock();
               phiBlock.addPhiVariable(blockNewPhis.get(symbol).getRef());
            }
         }
      }
      return (newPhis.size() == 0);
   }

   /**
    * Get all predecessors for a control flow block.
    * If the block is the start of an interrupt the @begin is included as a predecessor.
    * @param block The block to examine
    * @return All predecessor blocks
    */
   private List<ControlFlowBlock> getPredecessors(ControlFlowBlock block) {
      List<ControlFlowBlock> predecessors = getGraph().getPredecessors(block);
      Symbol symbol = getScope().getSymbol(block.getLabel());
      if(symbol instanceof Procedure) {
         if(((Procedure) symbol).getInterruptType()!=null) {
            // Find all root-level predecessors to the main block
            ControlFlowBlock mainBlock = getGraph().getBlock(new LabelRef(SymbolRef.MAIN_PROC_NAME));
            List<ControlFlowBlock> mainPredecessors = getGraph().getPredecessors(mainBlock);
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
   private Map<LabelRef, Map<VariableUnversioned, VariableVersion>> buildSymbolMap() {
      Map<LabelRef, Map<VariableUnversioned, VariableVersion>> symbolMap = new LinkedHashMap<>();
      for(ControlFlowBlock block : getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            if(statement instanceof StatementLValue) {
               StatementLValue assignment = (StatementLValue) statement;
               addSymbolToMap(symbolMap, block, assignment.getlValue());
            } else if(statement instanceof StatementPhiBlock) {
               StatementPhiBlock phiBlock = (StatementPhiBlock) statement;
               for(StatementPhiBlock.PhiVariable phiVariable : phiBlock.getPhiVariables()) {
                  addSymbolToMap(symbolMap, block, phiVariable.getVariable());
               }
            }
         }
      }
      return symbolMap;
   }

   private void addSymbolToMap(Map<LabelRef, Map<VariableUnversioned, VariableVersion>> symbolMap, ControlFlowBlock block, dk.camelot64.kickc.model.values.LValue lValue) {
      if(lValue instanceof VariableRef) {
         Variable lValueVar = getScope().getVariable((VariableRef) lValue);
         if(lValueVar instanceof VariableVersion) {
            VariableVersion versioned = (VariableVersion) lValueVar;
            LabelRef label = block.getLabel();
            VariableUnversioned unversioned = versioned.getVersionOf();
            Map<VariableUnversioned, VariableVersion> blockMap = symbolMap.get(label);
            if(blockMap == null) {
               blockMap = new LinkedHashMap<>();
               symbolMap.put(label, blockMap);
            }
            blockMap.put(unversioned, versioned);
         }
      }
   }
}
