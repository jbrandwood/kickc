package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Optimize assembler code by removing all unused labels
 */
public class Pass5RedundantLabelElimination extends Pass5AsmOptimization {

   public Pass5RedundantLabelElimination(Program program) {
      super(program);
   }

   public boolean optimize() {

      List<RedundantLabels> redundantLabelSet = findRedundantLabels();

      List<AsmLine> removeLines = new ArrayList<>();
      String currentScope = "";
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         for(AsmLine line : chunk.getLines()) {
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmBasicUpstart) {
               String labelStr = ((AsmBasicUpstart) line).getLabel();
               String labelReplacementStr = getLabelReplacement(redundantLabelSet, currentScope, labelStr);
               if(labelReplacementStr!=null) {
                  getLog().append("Replacing label " + labelStr + " with " + labelReplacementStr);
                  ((AsmBasicUpstart) line).setLabel(labelReplacementStr);
               }
            } else if(line instanceof AsmInstruction) {
               AsmInstruction instruction = (AsmInstruction) line;
               if(instruction.getCpuOpcode().isJump() && instruction.getOperandJumpTarget()!=null) {
                  String labelStr = instruction.getOperandJumpTarget();
                  String labelReplacementStr = getLabelReplacement(redundantLabelSet, currentScope, labelStr);
                  if(labelReplacementStr!=null) {
                     getLog().append("Replacing label " + labelStr + " with " + labelReplacementStr);
                     instruction.setOperandJumpTarget(labelReplacementStr);
                  }

               }

            } else if(line instanceof AsmLabel) {
               AsmLabel label = (AsmLabel) line;
               String labelStr = label.getLabel();
               if(!labelStr.contains("!")) {
                  for(RedundantLabels redundantLabels : redundantLabelSet) {
                     if(redundantLabels.getScope().equals(currentScope) && redundantLabels.isRedundant(labelStr)) {
                        removeLines.add(label);
                     }
                  }
               }
            }
         }
      }

      remove(removeLines);
      return removeLines.size() > 0;
   }

   /**
    * Look for a replacement for a label. Return the replacement if found.
    * @param redundantLabelSet The set of all redundant labels.
    * @param currentScope The current scope
    * @param labelStr The label string to replace
    * @return The replacement for the passed label. Null if it should not be replaced.
    */
   private String getLabelReplacement(List<RedundantLabels> redundantLabelSet, String currentScope, String labelStr) {
      String labelReplacementStr = null;
      if(!labelStr.contains("!")) {
         // If redundant - Replace with the shortest
         for(RedundantLabels redundantLabels : redundantLabelSet) {
            if(redundantLabels.getScope().equals(currentScope) && redundantLabels.isRedundant(labelStr)) {
               labelReplacementStr = redundantLabels.getKeep();
            }
         }
      }
      return labelReplacementStr;
   }

   /**
    * Find all redundant labels in the ASM
    *
    * @return List with all redundant labels
    */
   private List<RedundantLabels> findRedundantLabels() {
      List<RedundantLabels> redundantLabelSet = new ArrayList<>();
      RedundantLabels current = null;
      String currentScope = "";
      for(AsmChunk chunk : getAsmProgram().getChunks()) {
         for(AsmLine line : chunk.getLines()) {
            boolean handled = false;
            if(line instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) line).getLabel();
            } else if(line instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(line instanceof AsmLabel) {
               AsmLabel label = (AsmLabel) line;
               String labelStr = label.getLabel();
               if(!labelStr.contains("!")) {
                  if(current == null) {
                     current = new RedundantLabels(currentScope, labelStr);
                  } else {
                     current.add(labelStr);
                  }
                  handled = true;
               }
            }
            if(!handled) {
               if(current != null && current.size() > 1) {
                  redundantLabelSet.add(current);
               }
               current = null;
            }
         }
      }
      return redundantLabelSet;
   }


   private static class RedundantLabels {

      private String scope;

      private String keep;

      private Set<String> redundant;

      public RedundantLabels(String scope, String label) {
         this.scope = scope;
         this.keep = label;
         this.redundant = new LinkedHashSet<>();
      }

      public void add(String label) {
         if("__bbegin".equals(label)) {
            redundant.add(label);
            keep = label;
         } else if("__bbegin".equals(keep)) {
            redundant.add(label);
         } else if(keep.length() < label.length()) {
            redundant.add(label);
         } else {
            redundant.add(keep);
            keep = label;
         }
      }

      public int size() {
         return redundant.size() + 1;
      }

      public String getScope() {
         return scope;
      }

      public String getKeep() {
         return keep;
      }

      public boolean isRedundant(String labelStr) {
         return redundant.contains(labelStr);
      }
   }


}
