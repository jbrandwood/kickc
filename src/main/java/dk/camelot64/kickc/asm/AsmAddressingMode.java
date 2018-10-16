package dk.camelot64.kickc.asm;

import dk.camelot64.kickc.model.Program;

/** 6502 Assembler Instruction Addressing Modes. */
public enum AsmAddressingMode {
   NON("", "%i", 1),
   IMM("#imm", "%i #%p", 2),
   ZP("zp", "%i %p", 2),
   ZPX("zp,x", "%i %p,x", 2),
   ZPY("zp,y", "%i %p,y", 2),
   ABS("abs", "%i %p", 3),
   ABX("abs,x", "%i %p,x", 3),
   ABY("abs,y", "%i %p,y", 4),
   IZX("(zp,x)", "%i (%p,x)", 2),
   IZY("(zp),y", "%i (%p),y", 2),
   REL("rel", "%i %p", 2),
   IND("(ind)", "%i (%p)", 3);


   private String name;

   private String template;

   private int bytes;

   AsmAddressingMode(String name, String template, int bytes) {
      this.bytes = bytes;
      this.template = template;
      this.name = name;
   }

   public int getBytes() {
      return bytes;
   }

   public String getName() {
      return name;
   }

   public String getAsm(String mnemnonic, AsmParameter parameter) {
      String replaced = template.replace("%i", mnemnonic);
      if(parameter != null) {
         replaced = replaced.replace("%p", parameter.getAsm());
      }
      return replaced;
   }

}
