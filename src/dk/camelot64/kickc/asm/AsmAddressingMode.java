package dk.camelot64.kickc.asm;

/** 6502 Assembler Instruction Addressing Modes. */
public enum AsmAddressingMode {
   NON("", "%i", 1),
   IMM("#imm", "%i.imm #%p", 2),
   ZP("zp", "%i.zp %p", 2),
   ZPX("zp,x", "%i.zpx %p,x", 2),
   ZPY("zp,y", "%i.zpy %p,y", 2),
   ABS("abs", "%i.abs %p", 3),
   ABX("abs,x", "%i.abx %p,x", 3),
   ABY("abs,y", "%i.aby %p,y", 4),
   IZX("(zp,x)", "%i.izx (%p,x)", 2),
   IZY("(zp),y", "%i.izy (%p),y", 2),
   REL("rel", "%i.rel %p", 2),
   IND("(ind)", "%i.ind (%p)", 3);


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

   public String getAsm(String mnemnonic, String parameter) {
      String replaced = template.replace("%i", mnemnonic);
      if(parameter!=null) {
         replaced = replaced.replace("%p", parameter);
      }
      return replaced;
   }

}
