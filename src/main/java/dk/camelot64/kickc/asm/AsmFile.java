package dk.camelot64.kickc.asm;

import java.util.LinkedHashMap;
import java.util.Map;

/** Define a KickAss output file */
public class AsmFile implements AsmLine {

   private final String name;
   private final Map<String,String> parameters;
   private int index;

   public AsmFile(String name, Map<String, String> parameters) {
      this.name = name;
      this.parameters = parameters;
   }

   public AsmFile(String name) {
      this(name, new LinkedHashMap<>());
   }

   public AsmFile param(String paramName, String paramValue) {
      parameters.put(paramName, paramValue);
      return this;
   }

   @Override
   public int getLineBytes() {
      return 0;
   }

   @Override
   public double getLineCycles() {
      return 0;
   }

   @Override
   public String getAsm() {
      StringBuffer asm = new StringBuffer();
      asm.append(".file ").append(" [ ");
      asm.append("name=\"").append(name).append("\"");
      for(String paramName : parameters.keySet()) {
         asm.append(",");
         String paramValue = parameters.get(paramName);
         asm.append(paramName).append("=").append(paramValue);
      }
      asm.append(" ]");
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
}
