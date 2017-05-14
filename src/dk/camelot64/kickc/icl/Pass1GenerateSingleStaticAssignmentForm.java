package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/**
 * Compiler Pass that generates Single Static Assignment Form based on a Control Flow Graph.
 * <p>First versions all variable assignments, then versions all variable usages and introduces necessary Phi-functions,
 * <p>See https://en.wikipedia.org/wiki/Static_single_assignment_form
 */
public class Pass1GenerateSingleStaticAssignmentForm {

   private SymbolTable symbols;
   private ControlFlowGraph controlFlowGraph;

   public Pass1GenerateSingleStaticAssignmentForm(SymbolTable symbols, ControlFlowGraph controlFlowGraph) {
      this.symbols = symbols;
      this.controlFlowGraph = controlFlowGraph;
   }

   public void generate() {
      versionAllAssignments();
      versionAllUses();
      boolean done;
      do {
         System.out.println("Completing Phi functions...");
         done = completePhiFunctions();
      } while (!done);
   }

   /** Version all non-versioned non-intermediary being assigned a value. */
   private void versionAllAssignments() {
      for (ControlFlowBlock block : controlFlowGraph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getLValue();
               if (lValue instanceof VariableUnversioned) {
                  // Assignment to a non-versioned non-intermediary variable
                  VariableUnversioned assignedSymbol = (VariableUnversioned) lValue;
                  VariableVersion version = symbols.createVersion(assignedSymbol);
                  assignment.setLValue(version);
               }
            }
         }
      }
   }

   /** Version all uses of non-versioned non-intermediary variables */
   private void versionAllUses() {
      for (ControlFlowBlock block : controlFlowGraph.getAllBlocks()) {
         // Newest version of variables in the block.
         Map<VariableUnversioned, VariableVersion> blockVersions = new HashMap<>();
         // New phi functions introduced in the block to create versions of variables.
         Map<VariableUnversioned, VariableVersion> blockNewPhis = new HashMap<>();
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               {
                  VariableVersion version = findOrCreateVersion(assignment.getRValue1(), blockVersions, blockNewPhis);
                  if (version != null) {
                     assignment.setRValue1(version);
                  }
               }
               {
                  VariableVersion version = findOrCreateVersion(assignment.getRValue2(), blockVersions, blockNewPhis);
                  if (version != null) {
                     assignment.setRValue2(version);
                  }
               }
               // Update map of versions encountered in the block
               LValue lValue = assignment.getLValue();
               if (lValue instanceof VariableVersion) {
                  VariableVersion versioned = (VariableVersion) lValue;
                  blockVersions.put(versioned.getVersionOf(), versioned);
               }
            }
         }
         // Add new Phi functions to block
         for (VariableUnversioned symbol : blockNewPhis.keySet()) {
            block.addPhiStatement(blockNewPhis.get(symbol));
         }
      }
   }

   /**
    * Find and return the latest version of an rValue (if it is a non-versioned symbol).
    * If a version is needed and no version is found a new version is created as a phi-function.
    * @param rValue The rValue to examine
    * @param blockVersions The current version defined in the block for each symbol.
    * @param blockNewPhis New versions to be created as phi-functions. Modified if a new phi-function needs to be created.
    * @return Null if the rValue does not need versioning. The versioned symbol to use if it does.
    */
   private VariableVersion findOrCreateVersion(
         RValue rValue,
         Map<VariableUnversioned, VariableVersion> blockVersions,
         Map<VariableUnversioned, VariableVersion> blockNewPhis) {
      VariableVersion version = null;
      if (rValue instanceof VariableUnversioned) {
         // rValue needs versioning - look for version in statements
         VariableUnversioned rSymbol = (VariableUnversioned) rValue;
         version = blockVersions.get(rSymbol);
         if (version == null) {
            // look for version in new phi functions
            version = blockNewPhis.get(rSymbol);
         }
         if (version == null) {
            // create a new phi function
            version = symbols.createVersion(rSymbol);
            blockNewPhis.put(rSymbol, version);
         }
      }
      return version;
   }

   /** Look through all new phi-functions and fill out their parameters.
    * @return true if all phis were completely filled out.
    * false if new phis were added, meaning another iteration is needed.
    * */
   private boolean completePhiFunctions() {
      Map<ControlFlowBlock, Map<VariableUnversioned, VariableVersion>> newPhis = new HashMap<>();
      Map<Label, Map<VariableUnversioned, VariableVersion>> symbolMap = buildSymbolMap();
      for (ControlFlowBlock block : this.controlFlowGraph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               if (phi.getPreviousVersions().isEmpty()) {
                  VariableVersion versioned = phi.getLValue();
                  VariableUnversioned unversioned = versioned.getVersionOf();
                  for (ControlFlowBlock predecessor : block.getPredecessors()) {
                     Map<VariableUnversioned, VariableVersion> predecessorMap = symbolMap.get(predecessor.getLabel());
                     VariableVersion previousSymbol = null;
                     if (predecessorMap != null) {
                        previousSymbol = predecessorMap.get(unversioned);
                     }
                        if (previousSymbol == null) {
                           // No previous symbol found in predecessor block. Look in new a phi functions.
                           Map<VariableUnversioned, VariableVersion> predecessorNewPhis = newPhis.get(predecessor);
                           if (predecessorNewPhis == null) {
                              predecessorNewPhis = new HashMap<>();
                              newPhis.put(predecessor, predecessorNewPhis);
                           }
                           previousSymbol = predecessorNewPhis.get(unversioned);
                           if (previousSymbol == null) {
                              // No previous symbol found in predecessor block. Add a new phi function to the predecessor.
                              previousSymbol = symbols.createVersion(unversioned);
                              predecessorNewPhis.put(unversioned, previousSymbol);
                           }
                        }
                        phi.addPreviousVersion(predecessor, previousSymbol);
                     }
               }
            }
         }
      }
      // Ads new phi functions to blocks
      for (ControlFlowBlock block : controlFlowGraph.getAllBlocks()) {
         Map<VariableUnversioned, VariableVersion> blockNewPhis = newPhis.get(block);
         if (blockNewPhis != null) {
            for (VariableUnversioned symbol : blockNewPhis.keySet()) {
               block.addPhiStatement(blockNewPhis.get(symbol));
            }
         }
      }
      return (newPhis.size() == 0);
   }

   /**
    * Builds a map of all which versions each symbol has in each block.
    * Maps Control Flow Block Label -> ( Unversioned Symbol -> Versioned Symbol) for all relevant symbols.
    */
   private Map<Label, Map<VariableUnversioned, VariableVersion>> buildSymbolMap() {
      Map<Label, Map<VariableUnversioned, VariableVersion>> symbolMap = new HashMap<>();
      for (ControlFlowBlock block : this.controlFlowGraph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getLValue();
               if (lValue instanceof VariableVersion) {
                  VariableVersion versioned = (VariableVersion) lValue;
                  Label label = block.getLabel();
                  VariableUnversioned unversioned = versioned.getVersionOf();
                  Map<VariableUnversioned, VariableVersion> blockMap = symbolMap.get(label);
                  if (blockMap == null) {
                     blockMap = new HashMap<>();
                     symbolMap.put(label, blockMap);
                  }
                  blockMap.put(unversioned, versioned);
               }
            } else if (statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               VariableVersion versioned = phi.getLValue();
               VariableUnversioned unversioned = versioned.getVersionOf();
               Label label = block.getLabel();
               Map<VariableUnversioned, VariableVersion> blockMap = symbolMap.get(label);
               if (blockMap == null) {
                  blockMap = new HashMap<>();
                  symbolMap.put(label, blockMap);
               }
               blockMap.put(unversioned, versioned);
            }
         }
      }
      return symbolMap;
   }

}
