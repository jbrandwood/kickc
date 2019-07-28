package dk.camelot64.kickc.asm;

import java.util.List;

/**
 * A numeric data directive with an optional label.
 */
public class AsmDataNumeric implements AsmLine {

   /** Label - may be null. */
   private String label;
   /** The type of the data. */
   private Type type;
   /** The data elements. */
   private List<String> values;

   private int index;

   public AsmDataNumeric(String label, Type type, List<String> values) {
      this.label = label;
      this.type = type;
      this.values = values;
   }

   public int getElementBytes() {
      return type.bytes;
   }

   @Override
   public int getLineBytes() {
      return values.size() * getElementBytes();
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuilder asm = new StringBuilder();
      if(label != null) {
         asm.append(label + ": ");
      }
      asm.append("." + type.asm + " ");
      boolean first = true;
      for(String value : values) {
         if(!first)
            asm.append(", ");
         first = false;
         asm.append(value);
      }
      return asm.toString();
   }

   @Override
   public int getIndex() {
      return index;
   }

   @Override
   public void setIndex(int index) {
      this.index = index;
   }

   public static enum Type {
      BYTE("byte", 1),
      WORD("word", 2),
      DWORD("dword", 4);

      public final String asm;
      public final int bytes;

      Type(String asm, int bytes) {
         this.asm = asm;
         this.bytes = bytes;
      }

   }

}
