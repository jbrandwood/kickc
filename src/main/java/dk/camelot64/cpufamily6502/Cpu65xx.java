package dk.camelot64.cpufamily6502;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * A 6502 family CPU. The CPU has an instruction set.
 */
public class Cpu65xx {

   /** The CPU name. */
   private final String name;

   /** All opcodes in the instruction set. */
   private final List<CpuOpcode> allOpcodes;

   /** Maps mnemonic_addressingMode to the instruction opcode */
   private final Map<String, CpuOpcode> opcodesByMnemonicAddrMode;

   public Cpu65xx(String name) {
      this.name = name;
      this.allOpcodes = new ArrayList<>();
      this.opcodesByMnemonicAddrMode = new LinkedHashMap<>();
   }

   public Cpu65xx(String name, Cpu65xx basedOn) {
      this.name = name;
      this.allOpcodes = new ArrayList<>();
      this.opcodesByMnemonicAddrMode = new LinkedHashMap<>();
      for(CpuOpcode opcode : basedOn.allOpcodes) {
         addOpcode(opcode);
      }
   }

   /**
    * Add an instruction opcode to the instruction set.
    *
    * @param opcode The numeric opcode
    * @param mnemonic The lower case mnemonic
    * @param addressingMode The addressing mode
    * @param cycles The number of cycles
    */
   protected void addOpcode(int opcode, String mnemonic, CpuAddressingMode addressingMode, double cycles, String clobberString) {
      addOpcode(new int[opcode], mnemonic, addressingMode, cycles, clobberString);
   }

   /**
    * Add an instruction opcode to the instruction set.
    *
    * @param opcode The numeric opcodes
    * @param mnemonic The lower case mnemonic
    * @param addressingMode The addressing mode
    * @param cycles The number of cycles
    */
   protected void addOpcode(int[] opcode, String mnemonic, CpuAddressingMode addressingMode, double cycles, String clobberString) {
      addOpcode(new CpuOpcode(opcode, mnemonic, addressingMode, cycles, clobberString));
   }

   /**
    * Add an instruction opcode to the instruction set.
    *
    * @param cpuOpcode The opcode to add
    */
   private void addOpcode(CpuOpcode cpuOpcode) {
      allOpcodes.add(cpuOpcode);
      opcodesByMnemonicAddrMode.put(cpuOpcode.getMnemonic() + "_" + cpuOpcode.getAddressingMode().getName(), cpuOpcode);
   }


   /**
    * Get a specific instruction opcode form the instruction set
    *
    * @param mnemonic The mnemonic
    * @param addressingMode The addressing mode
    * @return The opcode, if is exists. Null if the instruction set does not have the opcode.
    */
   private CpuOpcode getOpcode(String mnemonic, CpuAddressingMode addressingMode) {
      String key = mnemonic.toLowerCase() + "_" + addressingMode.getName();
      return opcodesByMnemonicAddrMode.get(key);
   }

   /**
    * Get an opcode from the instruction set in either absolute or zeropage form.
    * This will try to find a zeropage-based addressing mode if you indicate that you are interested in that.
    *
    * @param mnemonic The mnemonic
    * @param addressingMode The addressing mode you want.
    * @param isOperandZp Indicates whether the operand is <256 meaning the opcode could be zeropage-based.
    * @return The opcode, if it exists. If you have requested an absolute addressing mode and pass isOperandZp as true the
    * resulting opcode will have zeropage-based addressing if the instruction set offers that.
    */
   public CpuOpcode getOpcode(String mnemonic, CpuAddressingMode addressingMode, boolean isOperandZp) {
      CpuOpcode cpuOpcode = null;
      if(CpuAddressingMode.ABS.equals(addressingMode) && isOperandZp) {
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.ZP);
      }
      if(CpuAddressingMode.ABX.equals(addressingMode) && isOperandZp) {
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.ZPX);
      }
      if(CpuAddressingMode.ABY.equals(addressingMode) && isOperandZp) {
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.ZPY);
      }
      if(CpuAddressingMode.IND.equals(addressingMode) && isOperandZp) {
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.INZ);
      }
      if(CpuAddressingMode.IAX.equals(addressingMode) && isOperandZp) {
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.IZX);
      }
      if(cpuOpcode == null) {
         // If the ZP-form does not exist use the ABS-variation
         cpuOpcode = getOpcode(mnemonic, addressingMode);
      }
      if(cpuOpcode == null && CpuAddressingMode.ABS.equals(addressingMode)) {
         // If the ABS-form does not exist try REL
         cpuOpcode = getOpcode(mnemonic, CpuAddressingMode.REL);
      }
      return cpuOpcode;
   }

}
