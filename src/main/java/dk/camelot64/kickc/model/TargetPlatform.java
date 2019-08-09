package dk.camelot64.kickc.model;

/**
 * The target platform the compiler is creating a program for.
 */
public enum TargetPlatform {
   /** Commodore 64 with BASIC upstart SYS-command. */
   C64BASIC("c64basic"),
   /** Commodore 64 with BASIC upstart SYS-command - using Code and Data segments. */
   C64BASIC_SEGMENTS("c64basic_segments"),
   /** 6502 assembler (with no upstart code.)*/
   ASM6502("asm6502"),
   /** 6502 assembler (with no upstart code.)*/
   ASM6502_SEGMENTS("asm6502_segments"),
   /** Custom target platform specified in a separate linker file passed using -T option or using #pragma link() */
   CUSTOM("custom");

   /** The default target platform. */
   public static final TargetPlatform DEFAULT = C64BASIC;

   /** The platform name. */
   private String name;

   TargetPlatform(String name) {
      this.name = name;
   }

   public String getName() {
      return name;
   }

   /** Get a target platform by name. */
   public static TargetPlatform getTargetPlatform(String name) {
      for(TargetPlatform value : TargetPlatform.values()) {
         if(value.getName().equalsIgnoreCase(name)) {
            return value;
         }
      }
      return null;
   }

}
