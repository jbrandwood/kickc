package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Symbol;

/** A reference to a symbol (variable, procedure or label) */
public class SymbolRef implements Value {

   public static final String BEGIN_BLOCK_NAME = "@begin";
   public static final String END_BLOCK_NAME = "@end";
   public static final String PROCEXIT_BLOCK_NAME = "@return";

   /** The full name of the variable. Allowing lookup in the symbol table. */
   private String fullName;

   public SymbolRef(String fullName) {
      this.fullName = fullName;
   }

   public String getFullName() {
      return fullName;
   }

   public void setFullName(String fullName) {
      this.fullName = fullName;
   }

   @Override
   public boolean equals(Object o) {
      if(this == o) {
         return true;
      }
      if(o == null || getClass() != o.getClass()) {
         return false;
      }

      SymbolRef symbolRef = (SymbolRef) o;

      return fullName != null ? fullName.equals(symbolRef.fullName) : symbolRef.fullName == null;
   }

   @Override
   public int hashCode() {
      return fullName != null ? fullName.hashCode() : 0;
   }

   @Override
   public String toString(Program program) {
      if(program == null) {
         return fullName;
      } else {
         try {
            Symbol symbol = program.getScope().getSymbol(fullName);
            if(symbol==null) {
               return fullName+"(null)";
            }
            return symbol.toString(program);
         } catch(NullPointerException e) {
            throw e;
         }
      }
   }

   public int getScopeDepth() {
      int depth = 0;
      char[] chars = fullName.toCharArray();
      for(char c : chars) {
         if(c == ':') depth++;
      }
      return depth / 2;
   }

   public boolean isVersion() {
      return fullName.contains("#");
   }

   public boolean isIntermediate() {
      if(
            fullName.contains(BEGIN_BLOCK_NAME) ||
                  fullName.contains(END_BLOCK_NAME)) return false;
      return fullName.contains("$") || fullName.contains("@");
   }

   public boolean isProcExit() {
      return fullName.endsWith(PROCEXIT_BLOCK_NAME);
   }

   public String getLocalName() {
      int lastScopeIdx = fullName.lastIndexOf("::");
      if(lastScopeIdx == -1) {
         return fullName;
      } else {
         return fullName.substring(lastScopeIdx + 2);
      }
   }

   public String getScopeNames() {
      int lastScopeIdx = fullName.lastIndexOf("::");
      if(lastScopeIdx == -1) {
         return "";
      } else {
         return fullName.substring(0, lastScopeIdx);
      }
   }

   @Override
   public String toString() {
      return getFullName();
   }

   public String getFullNameUnversioned() {
      if(isVersion()) {
         return fullName.substring(0, fullName.indexOf("#"));
      } else {
         return fullName;
      }

   }

}
