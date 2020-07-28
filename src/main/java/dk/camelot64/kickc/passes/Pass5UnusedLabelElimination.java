package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.statements.StatementAsm;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Optimize assembler code by removing all unused labels
 */
public class Pass5UnusedLabelElimination extends Pass5AsmOptimization {

   public Pass5UnusedLabelElimination(Program program) {
      super(program);
   }

   public boolean optimize() {
      Set<String> usedLabels = findUsedLabels();
      List<AsmLine> removeLines = findUnusedLabelLines(usedLabels);
      remove(removeLines);
      return removeLines.size() > 0;
   }

   /** Find all labels that are used. */
   private Set<String> findUsedLabels() {
      Set<String> usedLabels = new LinkedHashSet<>();
      String currentScope = "";
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         for(AsmLine line : chunk.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmBasicUpstart) {
               String labelStr = currentScope + "::" + ((AsmBasicUpstart) line).getLabel();
               usedLabels.add(labelStr);
            } else if(line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               if(instruction.getCpuOpcode().isJump() && instruction.getOperandJumpTarget()!=null) {
                  String labelStr = currentScope + "::" + instruction.getOperandJumpTarget();
                  usedLabels.add(labelStr);
               }
            }
         }
      }
      usedLabels.add("::"+getProgram().getStartProcedure().getLocalName());
      return usedLabels;
   }

   /** Find all ASM lines that are unused labels. */
   private List<AsmLine> findUnusedLabelLines(Set<String> usedLabels) {
      List<AsmLine> removeLines = new ArrayList<>();
      String currentScope = "";
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         Integer statementIdx = chunk.getStatementIdx();
         if(statementIdx != null) {
            Statement statement = getProgram().getStatementInfos().getStatement(statementIdx);
            if(statement instanceof StatementAsm) {
               // Skip ASM statement
               continue;
            }
         }
         for(AsmLine line : chunk.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmLabel) {
               AsmLabel label = (AsmLabel) line;
               if(label.isDontOptimize()) {
                  continue;
               }
               String labelStr = currentScope + "::" + label.getLabel();
               if(!labelStr.contains("!") && !usedLabels.contains(labelStr)) {
                  removeLines.add(label);
               }
            }
         }
      }
      return removeLines;
   }


}
