package dk.camelot64.kickc.model;

import dk.camelot64.cpufamily6502.Cpu65xx;
import dk.camelot64.cpufamily6502.cpus.*;
import kickass._65xx.cpus.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * The target CPU variation of the compile. Controls which instructions are legal.
 * CPU variations are also used to control whether the code compiled is meant for ROM - disallowing self-modifying cde.
 * */
public enum TargetCpu {
   /** Vanilla MOS 6502 CPU running in ROM - no illegal opcodes, no self-modifying code. */
   ROM6502("rom6502", CPU_6502NoIllegals.name, Cpu6502Official.INSTANCE, Collections.singletonList(Feature.MOS6502_COMMON)),
   /** MOS 6502 CPU running in ROM - allows illegal instructions, no self-modifying code. */
   ROM6502X("rom6502x", CPU_6502WithIllegals.name, Cpu6502Illegal.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_UNODC)),
   /** Vanilla MOS 6502 CPU - no illegal opcodes, allows self-modifying code. */
   MOS6502("mos6502", CPU_6502NoIllegals.name, Cpu6502Official.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_SELFMOD)),
   /** MOS 6502 CPU - allows illegal instructions, allows self-modifying code. */
   MOS6502X("mos6502x", CPU_6502WithIllegals.name, Cpu6502Illegal.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.MOS6502_UNODC, Feature.MOS6502_SELFMOD)),
   /** WDC 65C02 CPU - More addressing modes and instructions, no self-modifying code. http://westerndesigncenter.com/wdc/documentation/w65c02s.pdf */
   WDC65C02("wdc65c02", CPU_65C02.name, Cpu65C02.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.WDC65C02_COMMON, Feature.WDC65C02_SPECIFIC)),
   /** CSG 65CE02 CPU - Even more addressing modes and instructions, no self-modifying code. http://www.zimmers.net/anonftp/pub/cbm/documents/chipdata/65ce02.txt  */
   CSG65CE02("csg65ce02", CPU_65CE02.name, Cpu65CE02.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.WDC65C02_COMMON, Feature.CSG65CE02_COMMON)),
   /** 45GS02 CPU - Even more addressing modes and instructions, no self-modifying code. https://github.com/MEGA65/mega65-user-guide/blob/master/MEGA65-Book_draft.pdf  */
   MEGA45GS02("mega45gs02", CPU_45GS02.name, Cpu45GS02.INSTANCE, Arrays.asList(Feature.MOS6502_COMMON, Feature.WDC65C02_COMMON, Feature.CSG65CE02_COMMON, Feature.MEGA45GS02_COMMON)),
   ///** 65C186 CPU - 16-bit instructions, 24-bit addressing modes and more instructions. http://www.westerndesigncenter.com/wdc/documentation/w65c816s.pdf  */
   //WDC65C186("65C186"),
   ;

   /** The default target CPU */
   public static final TargetCpu DEFAULT = MOS6502X;

   /** A feature set of a CPU. The feature set is effectively a subset of the instruction set. In practice a feature is represented by a folder containing a number of fragments using the instructions. */
   public enum Feature {
      /** Official Instruction Set of the MOS 6502 CPU, which is also present on descendants. https://www.masswerk.at/6502/6502_instruction_set.html */
      MOS6502_COMMON("mos6502-common"),
      /** The Undocumented Opcodes of the MOS 6502 CPU, not present on descendant CPU's. http://www.oxyron.de/html/opcodes02.html */
      MOS6502_UNODC("mos6502-undoc"),
      /** Self-modifying Code using MOS 6502 instructions, not usable in ROM. */
      MOS6502_SELFMOD("mos6502-selfmod"),
      /** Added instructions of the WDC 65C02 CPU that are also present on the descendants 65CE02 and 45GS02. https://eater.net/datasheets/w65c02s.pdf */
      WDC65C02_COMMON("wdc65c02-common"),
      /** Instructions and features of the WDC 65C02 CPU that are not present on the descendants 65CE02 and 45GS02 (such as assuming that Z is always zero). https://eater.net/datasheets/w65c02s.pdf */
      WDC65C02_SPECIFIC("wdc65c02-specific"),
      /** Added instructions of the CSG 65CE02 CPU that are also present on the descendant 45GS02.  http://archive.6502.org/datasheets/mos_65ce02_mpu.pdf */
      CSG65CE02_COMMON("csg65ce02-common"),
      /** Added instructions of the MEGA 45GS02 CPU.  https://github.com/MEGA65/mega65-user-guide/blob/master/MEGA65-Book_draft.pdf */
      MEGA45GS02_COMMON("mega45gs02-common"),
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
   private final String name;

   /** The CPU name used by KickAsm */
   private final String asmName;

   /** The SM CPU knowing the instruction set. */
   private final Cpu65xx cpu65xx;

   /** Features of the CPU */
   private List<Feature> features;

   TargetCpu(String name, String asmName, Cpu65xx cpu65xx, List<Feature> features) {
      this.name = name;
      this.asmName = asmName;
      this.cpu65xx = cpu65xx;
      this.features = features;
   }

   public String getName() {
      return name;
   }

   public Cpu65xx getCpu65xx() {
      return cpu65xx;
   }

   /**
    * Get the name used by KickAsm
    * @return The CPU name used by KickAsm
    */
   public String getAsmName() {
      return asmName;
   }

   /**
    * Get the features of the CPU deciding which fragments is usable
    * @return The features
    */
   public List<Feature> getFeatures() {
      return features;
   }

   /** Get a target CPU by name. */
   public static TargetCpu getTargetCpu(String name, boolean missingOk) {
      for(TargetCpu value : TargetCpu.values()) {
         if(value.getName().equalsIgnoreCase(name)) {
            return value;
         }
      }
      if(missingOk)
         return null;
      StringBuilder supported = new StringBuilder();
      for(TargetCpu value : TargetCpu.values()) {
         supported.append(value.getName()).append(" ");
      }
      throw new CompileError("Unknown CPU. Supported: " + supported.toString());
   }

}
