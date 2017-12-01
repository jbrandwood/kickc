package dk.camelot64.kickc.model;

import dk.camelot64.kickc.passes.Pass3VariableReferenceInfos;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Map;

/**  Cached information about which variables are defined/referenced/used in statements / blocks. */
public class VariableReferenceInfos {

   /** The congtaining program. */
   private Program program;

   /** Variables referenced in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockReferenced;

   /** Variables used in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockUsed;

   /** Variables referenced in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtReferenced;

   /** Variables defined in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtDefined;

   /** The statement defining each variable. */
   private Map<VariableRef, Integer> varDefinitions;

   /** All statements referencing each variable . */
   private Map<VariableRef, Collection<Integer>> varReferences;

   public VariableReferenceInfos(
         Map<LabelRef, Collection<VariableRef>> blockReferenced,
         Map<LabelRef, Collection<VariableRef>> blockUsed,
         Map<Integer, Collection<VariableRef>> stmtReferenced,
         Map<Integer, Collection<VariableRef>> stmtDefined,
         Map<VariableRef, Integer> varDefinitions,
         Map<VariableRef, Collection<Integer>> varReferences

   ) {
      this.blockReferenced = blockReferenced;
      this.blockUsed = blockUsed;
      this.stmtDefined = stmtDefined;
      this.stmtReferenced = stmtReferenced;
      this.varDefinitions = varDefinitions;
      this.varReferences = varReferences;
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getReferenced(LabelRef labelRef) {
      return blockReferenced.get(labelRef);
   }

   /**
    * Get all variables used inside a block and its successors (including any called method)
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getUsed(LabelRef labelRef) {
      return blockUsed.get(labelRef);
   }

   /**
    * Get the variables defined by a statement
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   public Collection<VariableRef> getDefined(Statement stmt) {
      return stmtDefined.get(stmt.getIndex());
   }

   /**
    * Get the variables referenced (used or defined) in a statement
    * @param statement The statement to examine
    * @return The referenced variables
    */
   public Collection<VariableRef> getReferenced(Statement statement) {
      return stmtReferenced.get(statement.getIndex());
   }

   /**
    * Get the variables used, but not defined, in a statement
    * @param statement The statement to examine
    * @return The used variables (not including defined variables)
    */
   public Collection<VariableRef> getUsed(Statement statement) {
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      used.addAll(getReferenced(statement));
      used.removeAll(getDefined(statement));
      return used;
   }

   /**
    * Get all variables referenced in an rValue
    * @param rValue The rValue
    * @return All referenced variables
    */
   public static Collection<VariableRef> getReferenced(RValue rValue) {
      return Pass3VariableReferenceInfos.getReferenced(rValue);
   }

   /**
    * Determines if a variable is unused
    * @return true if the variable is defined but never referenced
    */
   public boolean isUnused(VariableRef variableRef) {
      Collection<Integer> refs = new LinkedHashSet<>(varReferences.get(variableRef));
      refs.remove(varDefinitions.get(variableRef));
      return refs.size()==0;
   }


}
