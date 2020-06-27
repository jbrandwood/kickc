package dk.camelot64.kickc.model.values;

import dk.camelot64.kickc.model.Program;
import dk.camelot64.kickc.model.symbols.Symbol;

import java.util.Objects;

/** A reference to a symbol (variable, procedure or label) */
public class SymbolRef implements Value {

   public static final String PROCEXIT_BLOCK_NAME = "@return";
   public static final String MAIN_PROC_NAME = "main";
   public static final String START_PROC_NAME = "__start";
   public static final String INIT_PROC_NAME = "__init";

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
      return Objects.equals(fullName, symbolRef.fullName);
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
         Symbol symbol = program.getScope().getGlobalSymbol(fullName);
         if(symbol == null) {
            return fullName + "(null)";
         }
         return symbol.toString(program);
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
