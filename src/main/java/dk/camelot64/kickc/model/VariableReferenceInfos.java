package dk.camelot64.kickc.model;

import dk.camelot64.kickc.model.statements.Statement;
import dk.camelot64.kickc.model.values.*;
import dk.camelot64.kickc.passes.calcs.PassNCalcVariableReferenceInfos;

import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Cached information about which variables/constants are defined/referenced/used in which statements / blocks / symbols .
 * <ul>
 * <li><i>Defined</i> means the variable/constant receives its value in a specific statement (or symbol for named constants) </li>
 * <li><i>Used</i> means the value of the variable/constant is used in a  specific statement (or symbol for named constants) </li>
 * <li><i>Referenced</i> means the variable/constant is either defined or referenced in a  specific statement (or symbol for named constants) </li>
 * </ul>
 */
public class VariableReferenceInfos {

   /** For each block this is the closure of all successor blocks. */
   private Map<LabelRef, Collection<LabelRef>> blockSuccessorClosure;

   /** References to variables/constants by block label. */
   private Map<LabelRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> blockVarReferences;

   /** References to variables/constants by statement index. */
   private Map<Integer, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> statementVarReferences;

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

      Integer getStatementIdx() {
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

      SymbolVariableRef getReferencingSymbol() {
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
         Map<LabelRef, Collection<LabelRef>> blockSuccessorClosure,
         Map<SymbolVariableRef, Collection<ReferenceToSymbolVar>> symbolVarReferences,
         Map<LabelRef, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> blockVarReferences,
         Map<Integer, Collection<VariableReferenceInfos.ReferenceToSymbolVar>> statementVarReferences
   ) {
      this.blockSuccessorClosure = blockSuccessorClosure;
      this.symbolVarReferences = symbolVarReferences;
      this.blockVarReferences = blockVarReferences;
      this.statementVarReferences = statementVarReferences;
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
      {
         sizeInfo.append("SIZE symbolVarReferences ").append(symbolVarReferences.size()).append(" SymbolVariableRefs ");
         int sub = 0;
         for(Collection<ReferenceToSymbolVar> value : symbolVarReferences.values()) {
            sub += value.size();
         }
         sizeInfo.append(" ").append(sub).append(" ReferenceToSymbolVars").append("\n");
      }
      {
         sizeInfo.append("SIZE statementVarReferences ").append(statementVarReferences.size()).append(" statements ");
         int sub = 0;
         for(Collection<ReferenceToSymbolVar> value : statementVarReferences.values()) {
            sub += value.size();
         }
         sizeInfo.append(" ").append(sub).append(" ReferenceToSymbolVars").append("\n");
      }
      {
         sizeInfo.append("SIZE blockVarReferences ").append(blockVarReferences.size()).append(" blocks ");
         int sub = 0;
         for(Collection<ReferenceToSymbolVar> value : blockVarReferences.values()) {
            sub += value.size();
         }
         sizeInfo.append(" ").append(sub).append(" ReferenceToSymbolVars").append("\n");
      }
      return sizeInfo.toString();
   }

   /**
    * Get all variables referenced in an rValue
    *
    * @param rValue The rValue
    * @return All referenced variables
    */
   public static Collection<VariableRef> getReferencedVars(RValue rValue) {
      return PassNCalcVariableReferenceInfos.getReferencedVars(rValue);
   }

   /**
    * Get all variables used or defined inside a block and its successors (including any called method)
    *
    * @param labelRef The block to examine
    * @return All used variables
    */
   public Collection<VariableRef> getReferencedVars(LabelRef labelRef) {
      ArrayList<VariableRef> variableRefs = new ArrayList<>();
      blockSuccessorClosure.get(labelRef)
            .forEach(labelRef1 -> blockVarReferences
                  .get(labelRef1)
                  .stream()
                  .filter(referenceToSymbolVar -> referenceToSymbolVar.getReferenced() instanceof VariableRef)
                  .forEach(referenceToSymbolVar -> {
                           if(!variableRefs.contains(referenceToSymbolVar.getReferenced()))
                              variableRefs.add((VariableRef) referenceToSymbolVar.getReferenced());
                        }
                  )
            );
      return variableRefs;
   }

   /**
    * Get the variables defined by a statement
    *
    * @param stmt The statement
    * @return Variables defined by the statement
    */
   public Collection<VariableRef> getDefinedVars(Statement stmt) {
      Collection<ReferenceToSymbolVar> referenceToSymbolVars = statementVarReferences.get(stmt.getIndex());
      // TODO: This may cause problems since it is a sign that the maps are out of date!
      if(referenceToSymbolVars==null)
         return new ArrayList<>();
      return referenceToSymbolVars
            .stream()
            .filter(referenceToSymbolVar -> referenceToSymbolVar.getReferenced() instanceof VariableRef)
            .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.DEFINE.equals(referenceToSymbolVar.getReferenceType()))
            .map(ReferenceToSymbolVar::getReferenced)
            .map(symbolVariableRef -> (VariableRef) symbolVariableRef)
            .collect(Collectors.toList());
   }

   /**
    * Get the variables referenced (used or defined) in a statement
    *
    * @param stmt The statement to examine
    * @return The referenced variables
    */
   public Collection<VariableRef> getReferencedVars(Statement stmt) {
      return statementVarReferences.get(stmt.getIndex())
            .stream()
            .filter(referenceToSymbolVar -> referenceToSymbolVar.getReferenced() instanceof VariableRef)
            .map(ReferenceToSymbolVar::getReferenced)
            .map(symbolVariableRef -> (VariableRef) symbolVariableRef)
            .collect(Collectors.toList());
   }

   /**
    * Get the variables used, but not defined, in a statement
    *
    * @param stmt The statement to examine
    * @return The used variables (not including defined variables)
    */
   public Collection<VariableRef> getUsedVars(Statement stmt) {
      return statementVarReferences.get(stmt.getIndex())
            .stream()
            .filter(referenceToSymbolVar -> referenceToSymbolVar.getReferenced() instanceof VariableRef)
            .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE.equals(referenceToSymbolVar.getReferenceType()))
            .map(ReferenceToSymbolVar::getReferenced)
            .map(symbolVariableRef -> (VariableRef) symbolVariableRef)
            .collect(Collectors.toList());
   }

   /**
    * Determines if a variable is unused
    *
    * @return true if the variable is defined but never referenced
    */
   public boolean isUnused(SymbolVariableRef variableRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(variableRef);
      if(refs == null)
         return true;
      final boolean noUses = refs.stream().noneMatch(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE.equals(referenceToSymbolVar.getReferenceType()));
      if(noUses)
         return true;

      // Some USEs exits - examine if the variable is DEFINEd in the same statement
      for(ReferenceToSymbolVar useRef : refs) {
         if(ReferenceToSymbolVar.ReferenceType.USE.equals(useRef.getReferenceType())) {
            // Found a USE - examine if it is also a DEFINE
            boolean unused = false;
            if(useRef instanceof ReferenceInStatement) {
               for(ReferenceToSymbolVar defRef : refs) {
                  if(defRef instanceof ReferenceInStatement && ReferenceToSymbolVar.ReferenceType.DEFINE.equals(defRef.getReferenceType())) {
                     if(((ReferenceInStatement) defRef).getStatementIdx().equals(((ReferenceInStatement) useRef).getStatementIdx()))
                        unused = true;
                  }
               }
            }
            if(!unused)
               return false;
         }
      }
      // All USE-references were inside DEFINE-statements - effectively the var is unused!
      return true;
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
      if(refs != null) {
         refs.stream()
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInStatement)
               .forEach(referenceToSymbolVar -> stmts.add(((ReferenceInStatement) referenceToSymbolVar).getStatementIdx()));
      }
      return stmts;
   }

   /**
    * Get the index of the statement defining a variable. Only returns if there is exactly one defining statement.
    *
    * @param variableRef The variable to look for
    * @return Index of the defining statement
    */
   public Integer getVarDefineStatement(VariableRef variableRef) {
      final Collection<Integer> stmts = getVarDefineStatements(variableRef);
      if(stmts.size() == 1)
         return stmts.iterator().next();
      else
         return null;
   }


   /**
    * Get all statements defining a variable
    *
    * @param varRef The variable to look for
    * @return Index of all statements defining the variable (ie. assigning a value to it)
    */
   public Collection<Integer> getVarDefineStatements(VariableRef varRef) {
      LinkedHashSet<Integer> stmts = new LinkedHashSet<>();
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(varRef);
      if(refs != null) {
         refs.stream()
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInStatement)
               .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.DEFINE.equals(referenceToSymbolVar.getReferenceType()))
               .forEach(referenceToSymbolVar -> stmts.add(((ReferenceInStatement) referenceToSymbolVar).statementIdx));
      }
      return stmts;
   }


   /**
    * Get all statements referencing a variable
    *
    * @param varRef The variable to look for
    * @return Index of all statements referencing the constant
    */
   public Collection<Integer> getVarRefStatements(SymbolVariableRef varRef) {
      Collection<ReferenceToSymbolVar> refs = symbolVarReferences.get(varRef);
      LinkedHashSet<Integer> stmts = new LinkedHashSet<>();
      if(refs != null) {
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
      if(refs != null) {
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
      if(refs != null) {
         refs.stream()
               .filter(referenceToSymbolVar -> ReferenceToSymbolVar.ReferenceType.USE.equals(referenceToSymbolVar.getReferenceType()))
               .filter(referenceToSymbolVar -> referenceToSymbolVar instanceof ReferenceInSymbol)
               .forEach(referenceToSymbolVar -> constRefs.add(((ReferenceInSymbol) referenceToSymbolVar).getReferencingSymbol()));
      }
      return constRefs;
   }

}
