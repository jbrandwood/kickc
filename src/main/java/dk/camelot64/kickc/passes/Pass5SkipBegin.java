package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.AsmBasicUpstart;
import dk.camelot64.kickc.asm.AsmChunk;
import dk.camelot64.kickc.asm.AsmInstruction;
import dk.camelot64.kickc.asm.AsmLine;
import dk.camelot64.kickc.model.ControlFlowBlock;
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
      ControlFlowBlock beginBlock = getProgram().getGraph().getBlock(new LabelRef(SymbolRef.BEGIN_BLOCK_NAME));
      boolean canSkip = canSkipBegin(beginBlock);
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
                  if(instruction.getType().getMnemnonic().equals("jsr")) {
                     if(instruction.getParameter().equals(SymbolRef.MAIN_PROC_NAME)) {
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

   /**
    * Examines whether the @begin/@end code can be skipped
    * This looks through all statements to check that the only one is a call to main()
    *
    * @param block The block to examine (initially the @begin block)
    * @return true if the @begin/@end code can be skipped
    */
   private boolean canSkipBegin(ControlFlowBlock block) {
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
         } else if(statement instanceof StatementKickAsm){
            // KASM-statements do not prevent skipping begin
         } else {
            return false;
         }
      }
      if(block.getConditionalSuccessor() != null) {
         return false;
      }
      if(block.getDefaultSuccessor() != null) {
         ControlFlowBlock successor = getProgram().getGraph().getBlock(block.getDefaultSuccessor());
         return canSkipBegin(successor);
      }
      return true;
   }
}
