package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.passes.PassNVariableReferenceInfos;

import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Map;

/**
 * Cached information about which variables/constants are defined/referenced/used in which statements / blocks / symbols .
 * <ul>
 * <li><i>Defined</i> means the variable/constant receives its value in a specific statement (or symbol for named constants) </li>
 * <li><i>Used</i> means the value of the variable/constant is used in a  specific statement (or symbol for named constants) </li>
 * <li><i>Referenced</i> means the variable/constant is either defined or referenced in a  specific statement (or symbol for named constants) </li>
 * </ul>
 */
public class VariableReferenceInfos {

   /** Variables referenced in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockReferencedVars;

   /** Variables used in each block. */
   private Map<LabelRef, Collection<VariableRef>> blockUsedVars;

   /** Variables referenced in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtReferencedVars;

   /** Variables defined in each statement. */
   private Map<Integer, Collection<VariableRef>> stmtDefinedVars;

   /** All references to symbol variables (constants/variables). References can be either statements or symbols in the symbol table */
   private Map<SymbolVariableRef, Collection<ReferenceToSymbolVar>> symbolVarReferences;

   /**
    * A reference of a symbol variable (variable or const).
    * The reference is either a specific statement or a symbol in the symbol table.
    * The reference can either be defining the symbol variable or it can be using it.
    */
   public interface ReferenceToSymbolVar {

      enum ReferenceType {USE, DEFINE}

      /**
       * Get the type of the reference
       *
       * @return The type of the reference (define or use)
       */
      ReferenceType getReferenceType();

      /**
       * Get the symbol being referenced
       *
       * @return The symbol being referenced
       */
      SymbolVariableRef getReferenced();

   }

   /** A reference to a variable/constant inside a statement. */
   public static class ReferenceInStatement implements ReferenceToSymbolVar {

      /** The index of the statement. */
      private Integer statementIdx;

      /** The type of reference. */
      private ReferenceType referenceType;

      /** The symbol being referenced. */
      private SymbolVariableRef referencedSymbol;

      public ReferenceInStatement(Integer statementIdx, ReferenceType referenceType, SymbolVariableRef referencedSymbol) {
         this.statementIdx = statementIdx;
         this.referenceType = referenceType;
         this.referencedSymbol = referencedSymbol;
      }

      public Integer getStatementIdx() {
         return statementIdx;
      }

      @Override
      public ReferenceType getReferenceType() {
         return referenceType;
      }

      @Override
      public SymbolVariableRef getReferenced() {
         return referencedSymbol;
      }
   }

   /** A reference to a variable/constant inside a symbol i he symbol table. */
   public static class ReferenceInSymbol implements ReferenceToSymbolVar {

      /** The symbol in the symbol table that contains the reference. */
      private SymbolVariableRef referencingSymbol;

      /** The type of reference. */
      private ReferenceType referenceType;

      /** The symbol being referenced. */
      private SymbolVariableRef referencedSymbol;

      public ReferenceInSymbol(SymbolVariableRef referencingSymbol, ReferenceType referenceType, SymbolVariableRef referencedSymbol) {
         this.referencingSymbol = referencingSymbol;
         this.referenceType = referenceType;
         this.referencedSymbol = referencedSymbol;
      }

      public SymbolVariableRef getReferencingSymbol() {
         return referencingSymbol;
      }

      @Override
      public ReferenceType getReferenceType() {
         return referenceType;
      }

      @Override
      public SymbolVariableRef getReferenced() {
         return referencedSymbol;
      }
   }

   public VariableReferenceInfos(
         Map<LabelRef, Collection<VariableRef>> blockReferencedVars,
         Map<LabelRef, Collection<VariableRef>> blockUsedVars,
         Map<Integer, Collection<VariableRef>> stmtReferencedVars,
         Map<Integer, Collection<VariableRef>> stmtDefinedVars,
         Map<SymbolVariableRef, Collection<ReferenceToSymbolVar>> symbolVarReferences

   ) {
      this.blockReferencedVars = blockReferencedVars;
      this.blockUsedVars = blockUsedVars;
      this.stmtDefinedVars = stmtDefinedVars;
      this.stmtReferencedVars = stmtReferencedVars;
      this.symbolVarReferences = symbolVarReferences;
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
   public boolean isUnused(SymbolVariableRef variableRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(variableRef);
      if(refs==null) return true;
      return !refs.stream()
            .anyMatch(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE.equals(referenceToSymbolVar.getReferenceType())
      );
   }

   /**
    * Get all statements referencing constant
    *
    * @param constRef The constant to look for
    * @return Index of all statements referencing the constant
    */
   public Collection<Integer> getConstRefStatements(ConstantRef constRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(constRef);
      LinkedHashSet<Integer> stmts = new LinkedHashSet<>();
      if(refs!=null) {
         refs.stream()
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInStatement)
               .forEach(referenceToSymbolVar -> stmts.add(((ReferenceInStatement) referenceToSymbolVar).getStatementIdx()));
      }
      return stmts;
   }

   /**
    * Get all statements referencing a variable
    *
    * @param varRef The variable to look for
    * @return Index of all statements referencing the constant
    */
   public Collection<Integer> getVarRefStatements(VariableRef varRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(varRef);
      LinkedHashSet<Integer> stmts = new LinkedHashSet<>();
      if(refs!=null) {
         refs.stream()
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInStatement)
               .forEach(referenceToSymbolVar -> stmts.add(((ReferenceInStatement) referenceToSymbolVar).getStatementIdx()));
      }
      return stmts;
   }

   /**
    * Get all statements using a variable
    *
    * @param varRef The variable to look for
    * @return Index of all statements using the variable (ie. referencing but not defining it)
    */
   public Collection<Integer> getVarUseStatements(VariableRef varRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(varRef);
      LinkedHashSet<Integer> stmts = new LinkedHashSet<>();
      if(refs!=null) {
         refs.stream()
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInStatement)
               .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE == referenceToSymbolVar.getReferenceType())
               .forEach(referenceToSymbolVar -> stmts.add(((ReferenceInStatement) referenceToSymbolVar).getStatementIdx()));
      }
      return stmts;
   }


   /**
    * Get all constants (or symbol definitions) referencing another constant
    *
    * @param constRef The constant to look for
    * @return All constants (or symbol definitions) that reference the constant in their value
    */
   public Collection<SymbolVariableRef> getSymbolRefConsts(ConstantRef constRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(constRef);
      LinkedHashSet<SymbolVariableRef> constRefs = new LinkedHashSet<>();
      if(refs!=null) {
         refs.stream()
               .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE.equals(referenceToSymbolVar.getReferenceType()))
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInSymbol)
               .forEach(referenceToSymbolVar -> constRefs.add(((ReferenceInSymbol) referenceToSymbolVar).getReferencingSymbol()));
      }
      return constRefs;
   }

}
