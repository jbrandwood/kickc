package dk.camelot64.kickc.model;

/** The target CPU variation of the compile. Controls which instructions are legal. */
public enum TargetCpu {
   /** Vanilla MOS 6502 CPU - without illegal opcodes. */
   MOS6502("MOS6502"),
   /** MOS 6502 CPU with support for illegal instructions. */
   MOS6502X("MOS6502X"),
   ///** 65C02 CPU - More addressing modes and instructions, no illegal instructions. http://westerndesigncenter.com/wdc/documentation/w65c02s.pdf */
   //WDC65C02("65C02"),
   ///** 65CE02 CPU - Even more addressing modes and instructions. http://www.zimmers.net/anonftp/pub/cbm/documents/chipdata/65ce02.txt  */
   //MOS65CE02("65CE02"),
   ///** 65C186 CPU - 16-bit instructions, 24-bit addressing modes and more instructions. http://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf  */
   //WDC65C186("65CE02"),
   ;

   /** The default target CPU. */
   public static final TargetCpu DEFAULT = MOS6502X;

   private String name;

   TargetCpu(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   /** Get a target CPU by name. */
   public static TargetCpu getTargetCpu(String name) {
      for(TargetCpu value : TargetCpu.values()) {
         if(value.getName().equalsIgnoreCase(name)) {
            return value;
         }
      }
      return null;
   }



}
