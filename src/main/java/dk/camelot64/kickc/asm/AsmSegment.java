package dk.camelot64.kickc.asm;

import java.util.LinkedHashMap;
import java.util.Map;

/** Selects a KickAss segment (defined using AsmSegmentDef)*/
public class AsmSegment implements AsmLine {

   private final String name;
   private final Map<String,String> parameters;
   private int index;

   public AsmSegment(String name, Map<String, String> parameters) {
      this.name = name;
      this.parameters = parameters;
   }

   public AsmSegment(String name) {
      this(name, new LinkedHashMap<>());
   }

   public AsmSegment param(String paramName, String paramValue) {
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
      asm.append(".segment ").append(name);
      if(parameters!=null && parameters.size()>0) {
         asm.append(" [ ");
         boolean first = true;
         for(String paramName : parameters.keySet()) {
            if(!first) asm.append(",");
            first = false;
            String paramValue = parameters.get(paramName);
            asm.append(paramName).append("=").append(paramValue);
         }
         asm.append(" ]");
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
}
