package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.symbols.Scope;

/** A reference to a scope */
public abstract class ScopeRef extends SymbolRef {

   public ScopeRef(String fullName) {
      super(fullName);
   }

   public ScopeRef(Scope scope) {
      super(scope.getFullName());
   }

   /**
    * Determines whether this scope is a sub-scope of the passe scope
    *
    * @param scope The scope to examine
    * @return true if the passed scope is a parent of the current scope. False if it is not a parent.
    * If the passed scope is equal to this scope false is also returned.
    */
   public boolean isSubScope(ScopeRef scope) {
      if(scope.getFullName().equals(this.getFullName())) {
         return false;
      }
      return getFullName().startsWith(scope.getFullName());

   }

   /**
    * Get the immediate parent scope of this scope.
    *
    * @return The parent scope. If this is a procedure the ROOT scope is returned. If this is the root scope null is returned.
    */
   public ScopeRef getParentScope() {
      // Assumes that scope depth uniquely determines the scope type
      if(ProgramScopeRef.PROGRAM_SCOPE_NAME.equals(getFullName())) {
         return null;
      }
      int parentIdx = getFullName().lastIndexOf("::");
      if(parentIdx == -1) {
         return ProgramScopeRef.ROOT;
      }
      String parentScopeFullName = getFullName().substring(0, parentIdx);
      if(parentScopeFullName.contains("::")) {
         return new BlockScopeRef(parentScopeFullName);
      } else {
         return new ProcedureRef(parentScopeFullName);
      }
   }

   /**
    * Get a parent scope of this scope
    *
    * @param levels The number of scope levels to return
    * @return A parent scope containing the number of requested scope levels.
    * If more levels are requested than are available an {@link IndexOutOfBoundsException} exception is thrown.
    */
   public ScopeRef getParentScope(int levels) throws IndexOutOfBoundsException {
      // Builds the full parent name in "parentScopeFullName" while removing the handled part from "scopesTodo"
      String scopesTodo = this.getFullName();
      String parentScopeFullName = "";
      for(int i = 0; i < levels; i++) {
         if(scopesTodo.length() == 0) {
            throw new IndexOutOfBoundsException("Index out of range " + levels + " in " + getFullName());
         }
         int scopeIdx = scopesTodo.indexOf("::");
         String scopeName;
         if(scopeIdx == -1) {
            scopeName = scopesTodo;
            scopesTodo = "";
         } else {
            scopeName = scopesTodo.substring(0, scopeIdx);
            scopesTodo = scopesTodo.substring(scopeIdx + 2);
         }
         if(parentScopeFullName.length() == 0) {
            parentScopeFullName = scopeName;
         } else {
            parentScopeFullName = parentScopeFullName + "::" + scopeName;
         }
      }
      if(parentScopeFullName.equals(ProgramScopeRef.PROGRAM_SCOPE_NAME)) {
         return ProgramScopeRef.ROOT;
      }
      if(parentScopeFullName.contains("::")) {
         return new BlockScopeRef(parentScopeFullName);
      } else {
         return new ProcedureRef(parentScopeFullName);
      }

   }

}
