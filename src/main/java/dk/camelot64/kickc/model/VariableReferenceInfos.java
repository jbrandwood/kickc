package dk.camelot64.kickc.model;

import dk.camelot64.kickc.passes.PassNVariableReferenceInfos;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Map;

/** Cached information about which variables are defined/referenced/used in statements / blocks. */
public class VariableReferenceInfos {

   /** Variables referenced in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockReferencedVars;

   /** Variables used in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockUsedVars;

   /** Variables referenced in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtReferencedVars;

   /** Variables defined in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtDefinedVars;

   /** The statement defining each variable. */
   private Map<VariableRef, Integer> varDefineStmt;

   /** All statements referencing each variable . */
   private Map<VariableRef, Collection<Integer>> varRefStmts;

   /** All statements referencing each constant. */
   private Map<ConstantRef, Collection<Integer>> constRefStmts;

   /** All constants referencing another constant. (maps from a constant to all constants using it in their value) */
   private Map<ConstantRef, Collection<ConstantRef>> constRefConsts;

   public VariableReferenceInfos(
         Map<LabelRef, Collection<VariableRef>> blockReferencedVars,
         Map<LabelRef, Collection<VariableRef>> blockUsedVars,
         Map<Integer, Collection<VariableRef>> stmtReferencedVars,
         Map<Integer, Collection<VariableRef>> stmtDefinedVars,
         Map<VariableRef, Integer> varDefineStmt,
         Map<VariableRef, Collection<Integer>> varRefStmts,
         Map<ConstantRef, Collection<Integer>> constRefStmts,
         Map<ConstantRef, Collection<ConstantRef>> constRefConsts

   ) {
      this.blockReferencedVars = blockReferencedVars;
      this.blockUsedVars = blockUsedVars;
      this.stmtDefinedVars = stmtDefinedVars;
      this.stmtReferencedVars = stmtReferencedVars;
      this.varDefineStmt = varDefineStmt;
      this.varRefStmts = varRefStmts;
      this.constRefStmts = constRefStmts;
      this.constRefConsts = constRefConsts;
   }

   /**
    * Get all variables referenced in an rValue
    *
    * @param rValue The rValue
    * @return All referenced variables
    */
   public static Collection<VariableRef> getReferencedVars(RValue rValue) {
      return PassNVariableReferenceInfos.getReferencedVars(rValue);
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getReferencedVars(LabelRef labelRef) {
      return blockReferencedVars.get(labelRef);
   }

   /**
    * Get all variables used inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getUsedVars(LabelRef labelRef) {
      return blockUsedVars.get(labelRef);
   }

   /**
    * Get the variables defined by a statement
    *
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   public Collection<VariableRef> getDefinedVars(Statement stmt) {
      return stmtDefinedVars.get(stmt.getIndex());
   }

   /**
    * Get the variables referenced (used or defined) in a statement
    *
    * @param statement The statement to examine
    * @return The referenced variables
    */
   public Collection<VariableRef> getReferencedVars(Statement statement) {
      return stmtReferencedVars.get(statement.getIndex());
   }

   /**
    * Get the variables used, but not defined, in a statement
    *
    * @param statement The statement to examine
    * @return The used variables (not including defined variables)
    */
   public Collection<VariableRef> getUsedVars(Statement statement) {
      LinkedHashSet<VariableRef> used = new LinkedHashSet<>();
      used.addAll(getReferencedVars(statement));
      used.removeAll(getDefinedVars(statement));
      return used;
   }

   /**
    * Determines if a variable is unused
    *
    * @return true if the variable is defined but never referenced
    */
   public boolean isUnused(VariableRef variableRef) {
      Collection<Integer> refs = new LinkedHashSet<>(varRefStmts.get(variableRef));
      refs.remove(varDefineStmt.get(variableRef));
      return refs.size() == 0;
   }

   /**
    * Determines if a constant is unused
    *
    * @return true if the constant is never referenced
    */
   public boolean isUnused(ConstantRef constRef) {
      Collection<Integer> constStmts = this.constRefStmts.get(constRef);
      Collection<ConstantRef> constRefs = constRefConsts.get(constRef);
      boolean unusedInStmts = constStmts == null || constStmts.size() == 0;
      boolean unusedInConsts = constRefs == null || constRefs.size() == 0;
      return unusedInStmts && unusedInConsts;
   }

   /**
    * Get all statements referencing constant
    * @param constRef The constant to look for
    * @return Index of all statements referencing the constant
    */
   public Collection<Integer> getConstRefStatements(ConstantRef constRef) {
      return constRefStmts.get(constRef);
   }


}
