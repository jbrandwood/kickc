package dk.camelot64.kickc.icl;

import java.util.HashMap;
import java.util.Map;

/**
 * Compiler Pass that generates Single Static Assignment Form based on a Control Flow Graph.
 * <p>First versions all variable assignments, then versions all variable usages and introduces necessary Phi-functions,
 * <p>See https://en.wikipedia.org/wiki/Static_single_assignment_form
 */
public class PassGenerateSingleStaticAssignmentForm {

   private SymbolManager symbols;
   private ControlFlowGraph controlFlowGraph;

   public PassGenerateSingleStaticAssignmentForm(SymbolManager symbols, ControlFlowGraph controlFlowGraph) {
      this.symbols = symbols;
      this.controlFlowGraph = controlFlowGraph;
   }

   public void generate() {
      versionAllAssignments();
      versionAllUses();
      boolean done = false;
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
               Symbol assignedSymbol = (Symbol) assignment.getlValue();
               if (!assignedSymbol.isIntermediate() && !assignedSymbol.isVersioned()) {
                  // Assignment to a non-versioned non-intermediary variable
                  Symbol version = symbols.createVersion(assignedSymbol);
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
         Map<Symbol, Symbol> blockVersions = new HashMap<>();
         // New phi functions introduced in the block to create versions of variables.
         Map<Symbol, Symbol> blockNewPhis = new HashMap<>();
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               {
                  Symbol version = findOrCreateVersion(assignment.getRValue1(), blockVersions, blockNewPhis);
                  if (version != null) {
                     assignment.setRValue1(version);
                  }
               }
               {
                  Symbol version = findOrCreateVersion(assignment.getRValue2(), blockVersions, blockNewPhis);
                  if (version != null) {
                     assignment.setRValue2(version);
                  }
               }
               // Update map of versions encountered in the block
               Symbol lSymbol = (Symbol) assignment.getlValue();
               if (lSymbol.isVersioned()) {
                  blockVersions.put(lSymbol.getVersionOf(), lSymbol);
               }
            }
         }
         // Add new Phi functions to block
         for (Symbol symbol : blockNewPhis.keySet()) {
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
   private Symbol findOrCreateVersion(RValue rValue, Map<Symbol, Symbol> blockVersions, Map<Symbol, Symbol> blockNewPhis) {
      Symbol version = null;
      if (rValue instanceof Symbol) {
         Symbol rSymbol = (Symbol) rValue;
         if (!rSymbol.isIntermediate() && !rSymbol.isVersioned()) {
            // rValue needs versioning - look for version in statements
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
      }
      return version;
   }

   /** Look through all new phi-functions and fill out their parameters.
    * @return true if all phis were completely filled out.
    * false if new phis were added , meaning another iteration is needed.
    * */
   private boolean completePhiFunctions() {
      Map<ControlFlowBlock, Map<Symbol, Symbol>> newPhis = new HashMap<>();
      Map<Symbol, Map<Symbol, Symbol>> symbolMap = buildSymbolMap();
      for (ControlFlowBlock block : this.controlFlowGraph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if (statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               if (phi.getPreviousVersions().isEmpty()) {
                  Symbol versioned = phi.getlValue();
                  Symbol unversioned = versioned.getVersionOf();
                  for (ControlFlowBlock predecessor : block.getPredecessors()) {
                     Symbol previousSymbol = symbolMap.get(predecessor.getLabel()).get(unversioned);
                     if (previousSymbol == null) {
                        // No previous symbol found in predecessor block. Look in new a phi functions.
                        Map<Symbol, Symbol> predecessorNewPhis = newPhis.get(predecessor);
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
         Map<Symbol, Symbol> blockNewPhis = newPhis.get(block);
         if(blockNewPhis!=null) {
            for (Symbol symbol : blockNewPhis.keySet()) {
               block.addPhiStatement(blockNewPhis.get(symbol));
            }
         }
      }
      return (newPhis.size()==0);
   }

   /**
    * Builds a map of all which versions each symbol has in each block.
    * Maps Control Flow Block Label -> ( Unversioned Symbol -> Versioned Symbol) for all relevant symbols.
    */
   private Map<Symbol, Map<Symbol, Symbol>> buildSymbolMap() {
      Map<Symbol, Map<Symbol, Symbol>> symbolMap = new HashMap<>();
      for (ControlFlowBlock block : this.controlFlowGraph.getAllBlocks()) {
         for (Statement statement : block.getStatements()) {
            if(statement instanceof StatementAssignment) {
               StatementAssignment assignment = (StatementAssignment) statement;
               LValue lValue = assignment.getlValue();
               if(lValue instanceof Symbol) {
                  Symbol symbol = (Symbol) lValue;
                  if(symbol.isVersioned()) {
                     Symbol label = block.getLabel();
                     Symbol unversioned = symbol.getVersionOf();
                     Symbol versioned = symbol;
                     Map<Symbol, Symbol> blockMap = symbolMap.get(label);
                     if(blockMap == null) {
                        blockMap = new HashMap<>();
                        symbolMap.put(label, blockMap);
                     }
                     blockMap.put(unversioned, versioned);
                  }
               }
            } else if(statement instanceof StatementPhi) {
               StatementPhi phi = (StatementPhi) statement;
               Symbol versioned = phi.getlValue();
               Symbol unversioned = versioned.getVersionOf();
               Symbol label = block.getLabel();
               Map<Symbol, Symbol> blockMap = symbolMap.get(label);
               if(blockMap == null) {
                  blockMap = new HashMap<>();
                  symbolMap.put(label, blockMap);
               }
               blockMap.put(unversioned, versioned);
            }
         }
      } return symbolMap;
   }


}
