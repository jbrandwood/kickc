package dk.camelot64.kickc.model;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * The target CPU variation of the compile. Controls which instructions are legal.
 * CPU variations are also used to control whether the code compiled is meant for ROM - disallowing self-modifying cde.
 * */
public enum TargetCpu {
   /** Vanilla MOS 6502 CPU running in ROM - no illegal opcodes, no self-modifying code. */
   ROM6502("rom6502", Collections.singletonList(Feature.MOS6502_COMMON)),
   /** MOS 6502 CPU running in ROM - allows illegal instructions, no self-modifying code. */
   ROM6502X("rom6502x", Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_UNODC)),
   /** Vanilla MOS 6502 CPU - no illegal opcodes, allows self-modifying code. */
   MOS6502("mos6502", Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_SELFMOD)),
   /** MOS 6502 CPU - allows illegal instructions, allows self-modifying code. */
   MOS6502X("mos6502x", Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_UNODC, Feature.MOS6502_SELFMOD)),
   ///** 65C02 CPU - More addressing modes and instructions, no illegal instructions. http://westerndesigncenter.com/wdc/documentation/w65c02s.pdf */
   //WDC65C02("65C02"),
   ///** 65CE02 CPU - Even more addressing modes and instructions. http://www.zimmers.net/anonftp/pub/cbm/documents/chipdata/65ce02.txt  */
   //MOS65CE02("65CE02"),
   ///** 65C186 CPU - 16-bit instructions, 24-bit addressing modes and more instructions. http://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf  */
   //WDC65C186("65CE02"),
   ;

   /** The default target CPU */
   public static final TargetCpu DEFAULT = MOS6502X;

   /** Feature of a CPU. A feature is represented by a folder containing a number of fragments. */
   public enum Feature {
      /** Official Instruction Set of the MOS6502 CPU. https://www.masswerk.at/6502/6502_instruction_set.html */
      MOS6502_COMMON("mos6502-common"),
      /** The Undocumented Opcodes of the MOS6502 CPU. http://www.oxyron.de/html/opcodes02.html */
      MOS6502_UNODC("mos6502-undoc"),
      /** Self-modifying Code using MOS6502 instructions. */
      MOS6502_SELFMOD("mos6502-selfmod"),
      ;

      /** The CPU feature name. */
      private String name;

      Feature(String name) {
         this.name = name;
      }

      public String getName() {
         return name;
      }
   }

   /** The name of the CPU. */
   private String name;

   /** Features of the CPU */
   private List<Feature> features;

   TargetCpu(String name, List<Feature> features) {
      this.name = name;
      this.features = features;
   }

   public String getName() {
      return name;
   }

   /**
    * Get the features of the CPU decising which fragments is usable
    * @return The features
    */
   public List<Feature> getFeatures() {
      return features;
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
