package dk.camelot64.kickc.icl;

import com.fasterxml.jackson.annotation.JsonIgnore;

/**  A program */
public class SymbolTypeProgram implements SymbolType {

   public SymbolTypeProgram() {

   }

   @Override
   @JsonIgnore
   public String getTypeName() {
      return "PROGRAM";
   }

   @Override
   public int hashCode() {
      return 331;
   }

   @Override
   public boolean equals(Object obj) {
      return (obj instanceof SymbolTypeProgram);
   }
}
