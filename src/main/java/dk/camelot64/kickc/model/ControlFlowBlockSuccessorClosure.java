package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.LabelRef;
import dk.camelot64.kickc.model.values.VariableRef;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

/** The transitive closure of control flow graph blocks */
public class ControlFlowBlockSuccessorClosure {

   /** For each block this is the closure of all successor blocks. */
   private Map<LabelRef, Collection<LabelRef>> blockSuccessorClosure;

   public ControlFlowBlockSuccessorClosure(Map<LabelRef, Collection<LabelRef>> blockSuccessorClosure) {
      this.blockSuccessorClosure = blockSuccessorClosure;
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getSuccessorClosureReferencedVars(LabelRef labelRef, VariableReferenceInfos varInfos) {
      ArrayList<VariableRef> variableRefs = new ArrayList<>();
      final Collection<LabelRef> successors = blockSuccessorClosure.get(labelRef);
      successors.forEach(labelRef1 -> variableRefs.addAll(varInfos.getReferencedVars(labelRef1)));
      return variableRefs;
   }


   public String getSizeInfo() {
      StringBuilder sizeInfo = new StringBuilder();
      if(blockSuccessorClosure != null) {
         sizeInfo.append("SIZE blockSuccessorClosure ").append(blockSuccessorClosure.size()).append(" labels ");
         int sub = 0;
         for(Collection<LabelRef> labelRefs : blockSuccessorClosure.values()) {
            sub += labelRefs.size();
         }
         sizeInfo.append(" ").append(sub).append(" labels").append("\n");
      }
      return sizeInfo.toString();
   }


}
