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
   }


   /**
    * Version all non-versioned non-intermediary being assigned a value.
    */
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

   /**
    * Version all uses of non-versioned non-intermediary variables
    */
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


}
