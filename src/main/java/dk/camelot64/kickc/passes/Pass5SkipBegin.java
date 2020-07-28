package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmBasicUpstart;
import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.model.ControlFlowBlock;
import dk.camelot64.kickc.model.ControlFlowGraph;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.*;
import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.ProcedureRef;
import dk.camelot64.kickc.model.values.SymbolRef;

import java.util.ListIterator;

/**
 * If the static code section from @begin to @end only has a call to main then modify BasicUpstart to call main directly
 */
public class Pass5SkipBegin extends Pass5AsmOptimization {

   public Pass5SkipBegin(Program program) {
      super(program);
   }

   public boolean optimize() {
      boolean canSkip = canSkipBegin(getProgram().getGraph());
      boolean optimized = false;
      if(canSkip) {
         // Change BasicUpstart() to call main directly and remove the JSR main
         for(AsmChunk chunk : getAsmProgram().getChunks()) {
            ListIterator<AsmLine> lineIterator = chunk.getLines().listIterator();
            while(lineIterator.hasNext()) {
               AsmLine line = lineIterator.next();
               if(line instanceof AsmBasicUpstart) {
                  AsmBasicUpstart basicUpstart = (AsmBasicUpstart) line;
                  if(!SymbolRef.MAIN_PROC_NAME.equals(basicUpstart.getLabel())) {
                     basicUpstart.setLabel(SymbolRef.MAIN_PROC_NAME);
                     optimized = true;
                     getLog().append("Updating BasicUpstart to call main directly");
                  }
               } else if(line instanceof AsmInstruction) {
                  AsmInstruction instruction = (AsmInstruction) line;
                  if(instruction.getCpuOpcode().getMnemonic().equals("jsr")) {
                     if(instruction.getOperandJumpTarget().equals(SymbolRef.MAIN_PROC_NAME)) {
                        lineIterator.remove();
                        optimized = true;
                        getLog().append("Removing instruction " + line.getAsm());
                     }
                  }
               }
            }
         }
      }
      return optimized;
   }

   static boolean canSkipBegin(ControlFlowGraph graph) {
      ControlFlowBlock beginBlock = graph.getBlock(new LabelRef(SymbolRef.START_PROC_NAME));
      return canSkipBegin(beginBlock, graph);
   }

   /**
    * Examines whether the @begin/@end code can be skipped
    * This looks through all statements to check that the only one is a call to main()
    *
    * @param block The block to examine (initially the @begin block)
    * @return true if the @begin/@end code can be skipped
    */
   private static boolean canSkipBegin(ControlFlowBlock block, ControlFlowGraph graph) {
      for(Statement statement : block.getStatements()) {
         if(statement instanceof StatementPhiBlock) {
            if(((StatementPhiBlock) statement).getPhiVariables().size() > 0) {
               return false;
            }
         } else if(statement instanceof StatementCalling) {
            ProcedureRef procedure = ((StatementCalling) statement).getProcedure();
            if(!SymbolRef.MAIN_PROC_NAME.equals(procedure.getFullName())) {
               return false;
            }
         } else if(statement instanceof StatementReturn && ((StatementReturn) statement).getValue() == null) {
            // Empty return do not prevent skipping begin
         } else if(statement instanceof StatementKickAsm) {
            // KASM-statements do not prevent skipping begin
         } else {
            return false;
         }
      }
      if(block.getConditionalSuccessor() != null) {
         return false;
      }
      if(block.getDefaultSuccessor() != null) {
         ControlFlowBlock successor = graph.getBlock(block.getDefaultSuccessor());
         if(successor != null)
            return canSkipBegin(successor, graph);
      }
      return true;
   }
}
