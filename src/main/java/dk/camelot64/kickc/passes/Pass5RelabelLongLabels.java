package dk.camelot64.kickc.passes;

import dk.camelot64.kickc.asm.*;
import dk.camelot64.kickc.model.Program;

import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Set;

/**
 * Relabel long labels in ASM code
 */
public class Pass5RelabelLongLabels extends Pass5AsmOptimization {

   public Pass5RelabelLongLabels(Program program) {
      super(program);
   }

   public boolean optimize() {
      boolean optimized = false;

      // Find all labels
      // Scope->Set<Labels>
      Map<String, Set<String>> allLabels = new LinkedHashMap<>();
      String currentScope = "";
      for(AsmChunk asmChunk : getAsmProgram().getChunks()) {
         for(AsmLine asmLine : asmChunk.getLines()) {
            if(asmLine instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) asmLine).getLabel();
            } else if(asmLine instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(asmLine instanceof AsmLabel) {
               AsmLabel asmLabel = (AsmLabel) asmLine;
               Set<String> scopeLabels = allLabels.get(currentScope);
               if(scopeLabels == null) {
                  scopeLabels = new LinkedHashSet<>();
                  allLabels.put(currentScope, scopeLabels);
               }
               scopeLabels.add(asmLabel.getLabel());
            }

         }
      }


      // Find relabels for all long labels
      // Scope->(Label->NewLabel)
      Map<String, Map<String, String>> relabels = new LinkedHashMap<>();
      for(AsmChunk asmChunk : getAsmProgram().getChunks()) {
         for(AsmLine asmLine : asmChunk.getLines()) {
            if(asmLine instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) asmLine).getLabel();
            } else if(asmLine instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(asmLine instanceof AsmLabel) {
               AsmLabel asmLabel = (AsmLabel) asmLine;
               if(asmLabel.getLabel().contains("_from_")) {
                  // Found a long label
                  Set<String> scopeLabels = allLabels.get(currentScope);
                  Map<String, String> scopeRelabels = relabels.get(currentScope);
                  if(scopeRelabels == null) {
                     scopeRelabels = new LinkedHashMap<>();
                     relabels.put(currentScope, scopeRelabels);
                  }
                  // Find new short unused label
                  int labelIdx = 1;
                  String newLabel = "__b" + labelIdx;
                  while(scopeLabels.contains(newLabel) || scopeRelabels.containsValue(newLabel)) {
                     newLabel = "__b" + labelIdx++;
                  }
                  getLog().append("Relabelling long label " + asmLabel.getLabel() + " to " + newLabel);
                  scopeRelabels.put(asmLabel.getLabel(), newLabel);
                  asmLabel.setLabel(newLabel);
               }
            }
         }
      }

      // Execute relabelling
      for(AsmChunk asmChunk : getAsmProgram().getChunks()) {
         for(AsmLine asmLine : asmChunk.getLines()) {
            if(asmLine instanceof AsmScopeBegin) {
               currentScope = ((AsmScopeBegin) asmLine).getLabel();
            } else if(asmLine instanceof AsmScopeEnd) {
               currentScope = "";
            } else if(asmLine instanceof AsmLabel) {
               AsmLabel asmLabel = (AsmLabel) asmLine;
               Map<String, String> scopeRelabels = relabels.get(currentScope);
               if(scopeRelabels != null) {
                  String newLabel = scopeRelabels.get(asmLabel.getLabel());
                  if(newLabel != null) {
                     asmLabel.setLabel(newLabel);
                  }
               }
            } else if(asmLine instanceof AsmInstruction) {
               AsmInstruction asmInstruction = (AsmInstruction) asmLine;
               if(asmInstruction.getCpuOpcode().isJump()) {
                  String parameter = asmInstruction.getOperandJumpTarget();
                  Map<String, String> scopeRelabels = relabels.get(currentScope);
                  if(scopeRelabels != null) {
                     String newLabel = scopeRelabels.get(parameter);
                     if(newLabel != null) {
                        asmInstruction.setOperandJumpTarget(newLabel);
                     }
                  }
               }
            }
         }
      }
      return relabels.size() > 0;
   }
}
