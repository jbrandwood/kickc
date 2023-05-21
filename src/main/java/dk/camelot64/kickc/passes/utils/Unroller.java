package dk.camelot64.kickc.passes.utils;

import dk.camelot64.kickc.model.*;
import dk.camelot64.kickc.model.iterator.ProgramValue;
import dk.camelot64.kickc.model.iterator.ProgramValueIterator;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.symbols.Label;
import dk.camelot64.kickc.model.symbols.Procedure;
import dk.camelot64.kickc.model.symbols.Scope;
import dk.camelot64.kickc.model.symbols.Variable;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.Pass1GenerateSingleStaticAssignmentForm;
import dk.camelot64.kickc.passes.calcs.PassNCalcVariableReferenceInfos;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

/**
 * Utility for copying blocks in a program - typically to unroll loops or conditions.
 * <p>
 * Unrolling has a number of phases
 * <ol>
 * <li>Prepare by ensuring that all successors of the blocks have PHI-statements for all variables defined inside the blocks </li>
 * <li>Copy all variables defined inside the blocks </li>
 * <li>Copy all block labels</li>
 * <li>Copy all blocks & statements - rewriting  all internal transitions in both original and copy according to a strategy.</li>
 * <li>Patch all predecessor blocks so they hit either the original or the new copied block according to a strategy.</li>
 * <li>Patch all successor blocks so they are now hit by both original and copy.</li>
 * </ol>
 * <p>
 * The {@link UnrollStrategy} defines
 * <ul>
 * <li> For each block transition entering the blocks being copied - should the transition hit the original or the copy?</li>
 * <li> For each block transition between two blocks being copied - should the transition be copied, always hit the original or always hit the copy?</li>
 * </ul>
 */
public class Unroller {

   /** The program. */
   private Program program;
   /** The blocks being copied/unrolled. */
   private BlockSet unrollBlocks;
   /** The strategy used for rewriting transitions into the block / inside the block. */
   private UnrollStrategy strategy;
   /** Maps variables defined in the original block to the copies of these variables defined in the new block. */
   private Map<SymbolVariableRef, SymbolVariableRef> varsOriginalToCopied;
   /** Maps labels of blocks in the original block to the labels of the copied blocks. */
   private Map<LabelRef, LabelRef> blocksOriginalToCopied;

   public Unroller(Program program, BlockSet unrollBlocks, UnrollStrategy unrollStrategy) {
      this.program = program;
      this.unrollBlocks = unrollBlocks;
      this.strategy = unrollStrategy;
   }

   /**
    * Perform unrolling by copying all specified blocks and updating block transitions according to the strategy
    */
   public void unroll() {
      // 0. Prepare for copying by ensuring that all variables defined in the blocks are represented in PHI-blocks of the successors
      prepare();
      if(program.getLog().isVerboseLoopUnroll()) {
         program.getLog().append("CONTROL FLOW GRAPH (PREPARED FOR LOOP HEAD UNROLL)");
         program.getLog().append(program.prettyControlFlowGraph());
      }
      // 1. Create new versions of all symbols assigned inside the loop
      this.varsOriginalToCopied = copyDefinedVars(unrollBlocks, program);
      // 2. Create new labels for all blocks in the loop
      this.blocksOriginalToCopied = copyBlockLabels(unrollBlocks, program);
      // 3. Copy all blocks being unrolled - rewriting internal transitions in both original and copy according to strategy
      unrollBlocks();
   }

   /**
    * Ensure that variables defined inside and used outside the blocks to be copied has different versions in different successors blocks.
    */
   private void prepare() {
      // TODO Handle variables modified inside called functions!
      for(SymbolVariableRef origVarRef : getVarsDefinedIn(unrollBlocks, program)) {
         // Find out if the variable is ever referenced outside the loop
         if(isReferencedOutside(origVarRef, unrollBlocks, program)) {
            // Re-version all usages of the specific variable version
            Map<LabelRef, SymbolVariableRef> newPhis = new LinkedHashMap<>();
            Map<LabelRef, SymbolVariableRef> varVersions = new LinkedHashMap<>();
            reVersionAllUsages(origVarRef, newPhis, varVersions);
            if(program.getLog().isVerboseLoopUnroll()) {
               program.getLog().append("Created new versions for " + origVarRef );
               //program.getLog().append(program.prettyControlFlowGraph());
            }
            // Recursively fill out & add PHI-functions until they have propagated everywhere needed
            completePhiFunctions(newPhis, varVersions);
         }
      }
   }

   /**
    * Find all usages of a variable and create new versions for each usage.
    *
    * @param origVarRef The original variable where all usages must have new versions
    * @param newPhis Map that will be populated with all new (empty) PHI-variables for the new versionw - these will be populated later.
    * @param varVersions Map that will be populated with the version of the origVariable at the end of each block where it has a defined version.
    */
   private void reVersionAllUsages(SymbolVariableRef origVarRef, Map<LabelRef, SymbolVariableRef> newPhis, Map<LabelRef, SymbolVariableRef> varVersions) {

      // First add the definition of origVar to varVersions
      for(var block : program.getGraph().getAllBlocks()) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = PassNCalcVariableReferenceInfos.getDefinedVars(statement);
            if(definedVars.contains(origVarRef)) {
               varVersions.put(block.getLabel(), origVarRef);
            }
         }
      }
      // Next iterate the entire graph ensuring that all usages create new versions (except usages right after the definition)
      for(var block : program.getGraph().getAllBlocks()) {
         AtomicReference<SymbolVariableRef> currentVersion = new AtomicReference<>();
         // Set current version from map
         currentVersion.set(varVersions.get(block.getLabel()));
         for(Statement statement : block.getStatements()) {
            ProgramValueIterator.execute(statement, (programValue, currentStmt, stmtIt, currentBlock) -> {
               Value value = programValue.get();
               if(origVarRef.equals(value)) {
                  // Found a reference!
                  if(statement instanceof StatementPhiBlock && programValue instanceof ProgramValue.PhiVariable) {
                     // This is the definition - don't replace it
                     currentVersion.set(origVarRef);
                     varVersions.put(block.getLabel(), origVarRef);
                  } else if(statement instanceof StatementLValue && programValue instanceof ProgramValue.ProgramValueLValue) {
                     // This is the definition - don't replace it
                     currentVersion.set(origVarRef);
                     varVersions.put(block.getLabel(), origVarRef);
                  } else if(statement instanceof StatementPhiBlock && programValue instanceof ProgramValue.PhiValue) {
                     // The reference is inside a PHI-value - we need a version in the predecessor
                     LabelRef predecessor = ((ProgramValue.PhiValue) programValue).getPredecessor();
                     SymbolVariableRef predecessorVersion = varVersions.get(predecessor);
                     if(predecessorVersion == null) {
                        // Add a new PHI to the predecessor
                        predecessorVersion = createNewVersion(origVarRef);
                        varVersions.put(predecessor, predecessorVersion);
                        newPhis.put(predecessor, predecessorVersion);
                     }
                     // Use the definition
                     programValue.set(predecessorVersion);
                  } else if(currentVersion.get() == null) {
                     // Found a reference - no definition - create a new version
                     SymbolVariableRef newVarRef = createNewVersion(origVarRef);
                     currentVersion.set(newVarRef);
                     varVersions.put(block.getLabel(), newVarRef);
                     newPhis.put(block.getLabel(), currentVersion.get());
                     // Use the definition
                     programValue.set(newVarRef);
                  } else {
                     programValue.set(currentVersion.get());
                  }
               }
            }, null, null);
         }
      }
      // Add the new empty PHI-blocks()
      for(LabelRef blockRef : newPhis.keySet()) {
         Graph.Block block = program.getGraph().getBlock(blockRef);
         SymbolVariableRef newVersion = newPhis.get(blockRef);
         block.getPhiBlock().addPhiVariable((VariableRef) newVersion);
      }

   }

   /**
    * Create a new version of a variable
    * @param origVarRef The original variable
    * @return The new version
    */
   private SymbolVariableRef createNewVersion(SymbolVariableRef origVarRef) {
      Variable origVar = program.getScope().getVariable(origVarRef);
      Scope scope = origVar.getScope();
      SymbolVariableRef newVarRef;
      if(origVarRef.isIntermediate()) {
         newVarRef = VariableBuilder.createIntermediate(scope, origVar.getType(), program).getRef();
      } else {
         newVarRef = (origVar).getPhiMaster().createVersion().getRef();
      }
      return newVarRef;
   }

   /**
    * Look through all new phi-functions and fill out their parameters.
    * Both passed maps are modified
    *
    * @param newPhis New (empty) PHI-variables for the new versions that need to be populated
    * @param varVersions Map with the version of the origVariable at the end of each block where it has a defined version.
    */
   private void completePhiFunctions(Map<LabelRef, SymbolVariableRef> newPhis, Map<LabelRef, SymbolVariableRef> varVersions) {
      Map<LabelRef, SymbolVariableRef> todo = newPhis;
      while(todo.size() > 0) {
         Map<LabelRef, SymbolVariableRef> doing = todo;
         todo = new LinkedHashMap<>();
         for(LabelRef blockRef : doing.keySet()) {
            SymbolVariableRef doingVarRef = doing.get(blockRef);
            Graph.Block block = program.getGraph().getBlock(blockRef);
            StatementPhiBlock.PhiVariable doingPhiVariable = block.getPhiBlock().getPhiVariable((VariableRef) doingVarRef);
            List<Graph.Block> predecessors = Pass1GenerateSingleStaticAssignmentForm.getPhiPredecessors(block, program);
            for(var predecessor : predecessors) {
               SymbolVariableRef predecessorVarRef = varVersions.get(predecessor.getLabel());
               if(predecessorVarRef == null) {
                  // Variable has no version in the predecessor block - add a new PHI and populate later!
                  SymbolVariableRef newVarRef = createNewVersion(doingVarRef);
                  predecessor.getPhiBlock().addPhiVariable((VariableRef) newVarRef);
                  //program.getLog().append("Adding PHI for "+newVarRef+" to "+predecessor.getLabel());
                  varVersions.put(predecessor.getLabel(), newVarRef);
                  todo.put(predecessor.getLabel(), newVarRef);
                  predecessorVarRef = newVarRef;
               }
               doingPhiVariable.setrValue(predecessor.getLabel(), predecessorVarRef);
            }
         }
         //program.getLog().append("Completing PHI-functions...");
         //program.getLog().append(program.prettyControlFlowGraph());
      }
   }

   /**
    * Create new versions of all symbols defined inside some blocks to be unrolled
    *
    * @param unrollBlocks The blocks being unrolled
    * @return A map from variables assigned inside the unroll blocks to the new copy of the variable
    */
   private static Map<SymbolVariableRef, SymbolVariableRef> copyDefinedVars(BlockSet unrollBlocks, Program program) {
      Map<SymbolVariableRef, SymbolVariableRef> definedToNewVar = new LinkedHashMap<>();
      for(VariableRef definedVarRef : getVarsDefinedIn(unrollBlocks, program)) {
         Variable definedVar = program.getScope().getVariable(definedVarRef);
         Variable newVar;
         if(definedVarRef.isIntermediate()) {
            Scope scope = definedVar.getScope();
            String name = scope.allocateIntermediateVariableName();
            newVar = Variable.createCopy(name, scope, definedVar);
            scope.add(newVar);
            definedToNewVar.put(definedVarRef, newVar.getRef());
         } else if(definedVarRef.isVersion()) {
            newVar = (definedVar).getPhiMaster().createVersion();
            definedToNewVar.put(definedVarRef, newVar.getRef());
         } else if(definedVar.isKindLoadStore()) {
            // New version not needed for load/store
         } else {
            throw new RuntimeException("Error! Variable is not versioned or intermediate " + definedVar.toString(program));
         }
         //getLog().append("Defined in loop: " + definedVarRef.getFullName() + " -> " + newVar.getRef().getFullName());
      }
      return definedToNewVar;
   }

   /**
    * Copy labels for all blocks to be unrolled. The new copies are named from the original name plus an integer suffix.
    *
    * @param unrollBlocks The blocks being copied
    * @return A map from each block label (to be unrolled) to the new copied labels
    */
   private static Map<LabelRef, LabelRef> copyBlockLabels(BlockSet unrollBlocks, Program program) {
      LinkedHashMap<LabelRef, LabelRef> blockToNewBlock = new LinkedHashMap<>();
      for(var block : unrollBlocks.getBlocks(program.getGraph())) {
         Scope blockScope = program.getScope().getScope(block.getScope());
         // Find the serial number
         int unrollSerial = 1;
         String localName = block.getLabel().getLocalName();
         int serialPos = localName.lastIndexOf("_");
         if(serialPos >= 0) {
            localName = localName.substring(0, serialPos);
         }
         String unrollLabelName;
         do {
            unrollLabelName = localName + "_" + unrollSerial++;
         } while(blockScope.getLocalLabel(unrollLabelName) != null);
         // Create a label
         Label unrollLabel = blockScope.addLabel(unrollLabelName);
         blockToNewBlock.put(block.getLabel(), unrollLabel.getRef());
      }
      return blockToNewBlock;
   }

   /**
    * Copy all blocks being unrolled in the control flow graph
    * - Unroll Statements (copy all statements, replace symbols properly (with the new versions / the versions assigned in the existing loop)
    * - Rewrite transitions in both original and copy according to the strategy
    */
   private void unrollBlocks() {
      for(var origBlock : unrollBlocks.getBlocks(program.getGraph())) {
         // Create the new block
         LabelRef newBlockLabel = blocksOriginalToCopied.get(origBlock.getLabel());
         ControlFlowBlock newBlock = new ControlFlowBlock(newBlockLabel, origBlock.getScope());

         // Add the new graph to the appropriate procedure
         final Procedure containingProcedure = program.getScope().getSymbol(origBlock.getLabel()).getContainingProcedure();
         final ProcedureCompilation procedureCompilation = program.getProcedureCompilation(containingProcedure.getRef());
         final List<Graph.Block> procedureBlocks = new ArrayList<>(procedureCompilation.getGraph().getAllBlocks());
         procedureBlocks.add(newBlock);
         procedureCompilation.setGraph(new ControlFlowGraph(procedureBlocks));


         for(Statement origStatement : origBlock.getStatements()) {
            Statement newStatement = unrollStatement(origStatement, origBlock.getLabel());
            newBlock.addStatement(newStatement);
            if(origStatement instanceof StatementConditionalJump) {
               // Update conditional successors
               origBlock.setConditionalSuccessor(((StatementConditionalJump) origStatement).getDestination());
               newBlock.setConditionalSuccessor(((StatementConditionalJump) newStatement).getDestination());
            } else if(newStatement instanceof StatementCall) {
               // Update call successors
               newBlock.setCallSuccessor(origBlock.getCallSuccessor());
            }
         }

         // Set default successor for both new & original blocks
         LabelRef origSuccessor = origBlock.getDefaultSuccessor();
         if(isInternal(origSuccessor)) {
            // Default Successor is inside copied blocks - Use strategy to find default successors
            UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(origBlock.getLabel(), origSuccessor);
            if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
               // The transition in both original and copy should go to the copy
               LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
               origBlock.setDefaultSuccessor(newSuccessor);
               newBlock.setDefaultSuccessor(newSuccessor);
            } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
               // The transition in both original and copy should go to the original
               newBlock.setDefaultSuccessor(origSuccessor);
            } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
               // The transition in the new copy should go between the newly copied blocks
               LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
               newBlock.setDefaultSuccessor(newSuccessor);
            }
         } else {
            // Default Successor is outside copied blocks
            // Set the same successor for the copied blocks as in the original
            newBlock.setDefaultSuccessor(origSuccessor);
            // Update the PHI blocks of the external default successor to also get values from the copied PHI block
            patchSuccessorBlockPhi(origSuccessor, origBlock.getLabel(), newBlockLabel);
         }

         // Examine whether conditional successor is external
         LabelRef origConditionalSuccessor = origBlock.getConditionalSuccessor();
         if(origConditionalSuccessor != null) {
            if(!isInternal(origConditionalSuccessor)) {
               // Update the PHI blocks of the external conditional successor to also get values from the copied PHI block
               patchSuccessorBlockPhi(origConditionalSuccessor, origBlock.getLabel(), newBlockLabel);
            }
         }

      }
   }

   /**
    * Determine if a block is one of the blovks being copied (original or copy)
    *
    * @param block The block to examine
    * @return true if the block is one of the blocks being copied
    */
   private boolean isInternal(LabelRef block) {
      return unrollBlocks.contains(block) || blocksOriginalToCopied.values().contains(block);

   }

   /**
    * Patch the PHI-block of an external successor block. Ensures that the PHI-block also receives data from the new copied block.
    *
    * @param successor The successor block's label
    * @param origBlock The label of the original block
    * @param newBlock The label of the newly created copy
    */
   private void patchSuccessorBlockPhi(LabelRef successor, LabelRef origBlock, LabelRef newBlock) {
      Graph.Block successorBlock = program.getGraph().getBlock(successor);
      StatementPhiBlock successorPhiBlock = successorBlock.getPhiBlock();
      for(StatementPhiBlock.PhiVariable phiVariable : successorPhiBlock.getPhiVariables()) {
         List<StatementPhiBlock.PhiRValue> phiRValues = phiVariable.getValues();
         ListIterator<StatementPhiBlock.PhiRValue> phiRValuesIt = phiRValues.listIterator();
         while(phiRValuesIt.hasNext()) {
            StatementPhiBlock.PhiRValue phiRValue = phiRValuesIt.next();
            if(phiRValue.getPredecessor().equals(origBlock)) {
               RValue newRValue = valueToNew(phiRValue.getrValue(), varsOriginalToCopied);
               phiRValuesIt.add(new StatementPhiBlock.PhiRValue(newBlock, newRValue));
            }
         }
      }
   }

   /**
    * Unroll a single statement inside a block.
    * Copy the statement, replace symbols properly (with the new versions if needed).
    * This includes handling any PHI-statements and successors
    *
    * @param origStatement The statement to unroll
    * @return The copied & unrolled statement
    */
   private Statement unrollStatement(Statement origStatement, LabelRef origBlock) {
      if(origStatement instanceof StatementPhiBlock) {
         return unrollStatementPhi((StatementPhiBlock) origStatement, origBlock);
      } else if(origStatement instanceof StatementAssignment) {
         StatementAssignment assignment = (StatementAssignment) origStatement;
         return new StatementAssignment(
               (LValue) valueToNew(assignment.getlValue(), varsOriginalToCopied),
               valueToNew(assignment.getrValue1(), varsOriginalToCopied),
               assignment.getOperator(),
               valueToNew(assignment.getrValue2(), varsOriginalToCopied),
               assignment.isInitialAssignment(),
               assignment.getSource(),
               Comment.NO_COMMENTS
         );
      } else if(origStatement instanceof StatementConditionalJump) {
         return unrollStatementConditionalJump((StatementConditionalJump) origStatement, origBlock);
      } else if(origStatement instanceof StatementCall) {
         StatementCall call = (StatementCall) origStatement;
         StatementCall newCall = new StatementCall(null, call.getProcedureName(), null, call.getSource(), Comment.NO_COMMENTS);
         newCall.setProcedure(call.getProcedure());
         return newCall;
      } else {
         throw new RuntimeException("Statement not handled by unroll " + origStatement);
      }
   }

   /**
    * Create a copy of a conditional jump statement. Also updates the original  conditional jump if specified by the strategy.
    *
    * @param origConditional The original conditional jump
    * @param origBlock The block containing the original PHI statement
    * @return The new copied conditional jump statement.
    */
   private Statement unrollStatementConditionalJump(StatementConditionalJump origConditional, LabelRef origBlock) {
      // First copy the statement
      StatementConditionalJump newConditional = new StatementConditionalJump(
            valueToNew(origConditional.getrValue1(), varsOriginalToCopied),
            origConditional.getOperator(),
            valueToNew(origConditional.getrValue2(), varsOriginalToCopied),
            origConditional.getDestination(),
            origConditional.getSource(),
            Comment.NO_COMMENTS
      );
      newConditional.setDeclaredUnroll(origConditional.isDeclaredUnroll());
      // Then make sure the destination is correct in both the original and copy
      LabelRef origSuccessor = origConditional.getDestination();
      if(isInternal(origSuccessor)) {
         // Successor is inside the copied blocks!
         UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(origBlock, origSuccessor);
         if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
            // The transition in both original and copy should go to the copy
            LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
            origConditional.setDestination(newSuccessor);
            newConditional.setDestination(newSuccessor);
         } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
            // The transition in both original and copy should go to the original
            // No action necessary since both original & copy already point to the original successor
         } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
            // The transition in the new copy should go between the newly copied blocks
            LabelRef newSuccessor = blocksOriginalToCopied.get(origSuccessor);
            newConditional.setDestination(newSuccessor);
         }
      } else {
         // Successor is outside the copied blocks!
         // No action necessary since both original & copy already point to the successor
      }
      return newConditional;
   }

   /**
    * Create a copy of a PHI-statement. Also updates the original PHI-statement if specified by the strategy.
    *
    * @param origPhiBlock The original PHI statement
    * @param origBlock The block containing the original PHI statement
    * @return The new copied PH statement.
    */
   private Statement unrollStatementPhi(StatementPhiBlock origPhiBlock, LabelRef origBlock) {
      StatementPhiBlock newPhiBlock = new StatementPhiBlock(Comment.NO_COMMENTS);
      for(StatementPhiBlock.PhiVariable origPhiVariable : origPhiBlock.getPhiVariables()) {
         SymbolVariableRef origPhiVar = origPhiVariable.getVariable();
         SymbolVariableRef newPhiVar = varsOriginalToCopied.get(origPhiVar);
         StatementPhiBlock.PhiVariable newPhiVariable = newPhiBlock.addPhiVariable((VariableRef) newPhiVar);
         List<StatementPhiBlock.PhiRValue> origPhiRValues = origPhiVariable.getValues();
         ListIterator<StatementPhiBlock.PhiRValue> origPhiRValuesIt = origPhiRValues.listIterator();
         while(origPhiRValuesIt.hasNext()) {
            StatementPhiBlock.PhiRValue origPhiRValue = origPhiRValuesIt.next();
            LabelRef predecessor = origPhiRValue.getPredecessor();
            if(isInternal(predecessor)) {
               // Predecessor is inside the loop
               UnrollStrategy.TransitionHandling handling = strategy.getInternalStrategy(predecessor, origBlock);
               if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
                  // The transition in both original and copy should go to the copy
                  // - First create new entry from the new predecessor block
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  newPhiVariable.setrValue(blocksOriginalToCopied.get(predecessor), rValueNew);
                  // - Then an entry from the existing predecessor block
                  RValue rValue = copyValue(origPhiRValue.getrValue());
                  newPhiVariable.setrValue(predecessor, rValue);
                  // Finally remove the phi entry into the original block (since both will hit the new block)
                  origPhiRValuesIt.remove();
               } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
                  // The transition in both original and copy should go to the original
                  // Create new entry in the original block from the new predecessor block
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  origPhiRValuesIt.add(new StatementPhiBlock.PhiRValue(blocksOriginalToCopied.get(predecessor), rValueNew));
               } else if(UnrollStrategy.TransitionHandling.TO_BOTH.equals(handling)) {
                  // The transition in the new copy should go between the newly copied blocks
                  RValue rValueNew = valueToNew(origPhiRValue.getrValue(), varsOriginalToCopied);
                  newPhiVariable.setrValue(blocksOriginalToCopied.get(predecessor), rValueNew);
               }
            } else {
               // Predecessor is outside loop
               UnrollStrategy.TransitionHandling handling = strategy.getEntryStrategy(predecessor, origBlock);
               if(UnrollStrategy.TransitionHandling.TO_COPY.equals(handling)) {
                  // The transition should go to the new copy
                  newPhiVariable.setrValue(predecessor, origPhiRValue.getrValue());
                  // Remove the phi entry into the original block since only the new block is hit
                  origPhiRValuesIt.remove();
                  // Update the successor in the predecessor block to point to the new copy
                  Graph.Block predecessorBlock = program.getGraph().getBlock(predecessor);
                  LabelRef newBlock = blocksOriginalToCopied.get(origBlock);
                  if(origBlock.equals(predecessorBlock.getDefaultSuccessor())) {
                     predecessorBlock.setDefaultSuccessor(newBlock);
                  } else if(origBlock.equals(predecessorBlock.getConditionalSuccessor())) {
                     predecessorBlock.setConditionalSuccessor(newBlock);
                     for(Statement predecessorStatement : predecessorBlock.getStatements()) {
                        if(predecessorStatement instanceof StatementConditionalJump) {
                           ((StatementConditionalJump) predecessorStatement).setDestination(newBlock);
                        }
                     }
                  }
               } else if(UnrollStrategy.TransitionHandling.TO_ORIGINAL.equals(handling)) {
                  // The transition should go to the original
                  // Do nothing!
               }
            }
         }
      }
      return newPhiBlock;
   }

   /**
    * Any variable references inside the value points to variables in the new copied version of the copied blocks
    * Creates a copy of the passed value object (to avoid that two parts of the model points to the same object).
    *
    * @param rValue The rValue to update
    * @param definedToNewVar Map from variables defined in the original loop to the variables in the new unrolled "rest" loop
    * @return A copy of the RValue with all relevant variable references updated
    */
   private static RValue valueToNew(RValue rValue, Map<SymbolVariableRef, SymbolVariableRef> definedToNewVar) {
      if(rValue == null) return null;
      RValue rValueCopy = copyValue(rValue);
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValueCopy);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rVal = programValue.get();
         if(rVal instanceof VariableRef) {
            if(definedToNewVar.get(rVal) != null) {
               programValue.set(definedToNewVar.get(rVal));
            }
         }
      }, null, null, null);
      return (RValue) genericValue.get();
   }

   /**
    * Any variable references inside the value points to variables in the original version of the copied blocks
    * Creates a copy of the passed value object (to avoid that two parts of the model points to the same object).
    *
    * @param rValue The value to copy
    * @return An exact copy of the value
    */
   public static RValue copyValue(RValue rValue) {
      if(rValue == null) return null;
      ProgramValue.GenericValue genericValue = new ProgramValue.GenericValue(rValue);
      ProgramValueIterator.execute(genericValue, (programValue, currentStmt, stmtIt, currentBlock) -> {
         Value rVal = programValue.get();
         if(rVal instanceof PointerDereferenceSimple) {
            programValue.set(new PointerDereferenceSimple(((PointerDereferenceSimple) rVal).getPointer()));
         } else if(rVal instanceof PointerDereferenceIndexed) {
            programValue.set(new PointerDereferenceIndexed(((PointerDereferenceIndexed) rVal).getPointer(), ((PointerDereferenceIndexed) rVal).getIndex()));
         } else if(rVal instanceof CastValue) {
            programValue.set(new CastValue(((CastValue) rVal).getToType(), ((CastValue) rVal).getValue()));
         } else if(rVal instanceof ValueList) {
            programValue.set(new ValueList(new ArrayList<>(((ValueList) rVal).getList())));
         }
      }, null, null, null);
      return (RValue) genericValue.get();
   }

   /** Strategy for handling transitions into blocks that have been copied */
   public interface UnrollStrategy {

      /** Specifies where a transition destination should be after the unrolling. */
      enum TransitionHandling {
         /** The transition should go the original block */
         TO_ORIGINAL,
         /** The transition should go the copied block */
         TO_COPY,
         /** The transition should be copied itself (only legal for transitions where both blocks have been copied) */
         TO_BOTH
      }

      /**
       * Find out how to handle a transition going into the blocks being copied.
       *
       * @param from The predecessor block of the transition (outside the copied blocks)
       * @param to The (original) destination block of the transition (inside the copied blocks).
       * @return Whether the transition should hit the original or the copy in the modified graph.
       */
      TransitionHandling getEntryStrategy(LabelRef from, LabelRef to);

      /**
       * Find out how to handle a transition between two blocks being copied.
       *
       * @param from The predecessor block of the transition (inside the copied blocks)
       * @param to The (original) destination block of the transition (inside the copied blocks).
       * @return Whether the transition should be copied itself, always go to the original or always to the copy.
       */
      TransitionHandling getInternalStrategy(LabelRef from, LabelRef to);

   }

   /**
    * Find all transitions where the flow of control leaves a block set
    *
    * @param blockSet The loop to examine
    * @param graph The control flow graph
    * @return All transitions leaving the block set
    */
   private static List<SuccessorTransition> getSuccessorTransitions(BlockSet blockSet, ControlFlowGraph graph) {
      List<SuccessorTransition> successorTransitions = new ArrayList<>();
      for(var block : blockSet.getBlocks(graph)) {
         if(block.getDefaultSuccessor() != null && !blockSet.getBlocks().contains(block.getDefaultSuccessor())) {
            // Default successor is outside
            successorTransitions.add(new SuccessorTransition(block.getDefaultSuccessor(), block.getLabel()));
         }
         if(block.getConditionalSuccessor() != null && !blockSet.getBlocks().contains(block.getConditionalSuccessor())) {
            // Conditional successor is outside
            successorTransitions.add(new SuccessorTransition(block.getConditionalSuccessor(), block.getLabel()));
         }
      }
      return successorTransitions;
   }

   /** Information about a transition leaving a block set - ie. a transition from a block inside the set to a successor block outside. */
   public static class SuccessorTransition {
      /** A block that is the successor to a block in the set. */
      LabelRef successor;
      /** The block inside the set that is the predecessor of the successor block. */
      LabelRef predecessor;

      SuccessorTransition(LabelRef successor, LabelRef predecessor) {
         this.successor = successor;
         this.predecessor = predecessor;
      }
   }

   /**
    * Determine whether a variable is referenced outside a block set
    *
    * @param variableRef The variable
    * @param blockSet The block set
    * @param program The program
    * @return true if the variable is ever referenced outside the block set
    */
   private static boolean isReferencedOutside(SymbolVariableRef variableRef, BlockSet blockSet, Program program) {
      boolean referencedOutside = false;
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      StatementInfos statementInfos = program.getStatementInfos();
      Collection<Integer> varRefStatements = variableReferenceInfos.getVarRefStatements(variableRef);
      for(Integer varRefStatement : varRefStatements) {
         Graph.Block refBlock = statementInfos.getBlock(varRefStatement);
         if(!blockSet.getBlocks().contains(refBlock.getLabel())) {
            referencedOutside = true;
            break;
         }
      }
      return referencedOutside;
   }

   /**
    * Get all variables defined inside the blocks
    *
    * @param blockSet The blocks to be unrolled
    * @param program The program
    * @return All variables defined inside the blocks to be unrolled
    */
   private static List<VariableRef> getVarsDefinedIn(BlockSet blockSet, Program program) {
      VariableReferenceInfos variableReferenceInfos = program.getVariableReferenceInfos();
      List<VariableRef> definedInBlocks = new ArrayList<>();
      for(var block : blockSet.getBlocks(program.getGraph())) {
         for(Statement statement : block.getStatements()) {
            Collection<VariableRef> definedVars = variableReferenceInfos.getDefinedVars(statement);
            definedInBlocks.addAll(definedVars);
         }
      }
      return definedInBlocks;
   }

}
