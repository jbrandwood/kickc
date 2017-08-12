package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonIgnore;
import dk.camelot64.kickc.passes.Pass1GenerateControlFlowGraph;

/** A reference to a symbol (variable, procedure or label) */
public class SymbolRef implements Value {

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
      if (this == o) {
         return true;
      }
      if (o == null || getClass() != o.getClass()) {
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
      if (program == null) {
         return fullName;
      } else {
         return program.getScope().getSymbol(fullName).toString(program);
      }
   }

   @JsonIgnore
   public int getScopeDepth() {
      int depth = 0;
      char[] chars = fullName.toCharArray();
      for (char c : chars) {
         if(c==':') depth++;
      }
      return depth/2;
   }

   @JsonIgnore
   public boolean isVersion() {
      return fullName.contains("#");
   }

   @JsonIgnore
   public boolean isIntermediate() {
      if(
            fullName.contains(Pass1GenerateControlFlowGraph.BEGIN_BLOCK_NAME) ||
                  fullName.contains(Pass1GenerateControlFlowGraph.END_BLOCK_NAME) ) return false;
      return fullName.contains("$") || fullName.contains("@");
   }

   @JsonIgnore
   public boolean isProcExit() {
      return fullName.endsWith("@return");
   }

   @JsonIgnore
   public String getLocalName() {
      int lastScopeIdx = fullName.lastIndexOf("::");
      if(lastScopeIdx==-1) {
         return fullName;
      } else {
         return fullName.substring(lastScopeIdx+2);
      }
   }

   @JsonIgnore
   public String getScopeNames() {
      int lastScopeIdx = fullName.lastIndexOf("::");
      if(lastScopeIdx==-1) {
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
      }  else {
         return fullName;
      }

   }

}
