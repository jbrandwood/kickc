package dk.camelot64.cpufamily6502;

import java.util.*;

/**
 * A 6502 family CPU. The CPU has an instruction set.
 */
public class AsmCpu {

   /**  The CPU name. */
   private final String name;

   /** All opcodes in the instruction set. */
   private final List<AsmOpcode> allOpcodes;

   /** Maps mnemonic_addressingMode to the instruction opcode */
   private final Map<String, AsmOpcode> opcodesByMnemonicAddrMode;

   public AsmCpu(String name) {
      this.name = name;
      this.allOpcodes = new ArrayList<>();
      this.opcodesByMnemonicAddrMode = new LinkedHashMap<>();
   }

   public AsmCpu(String name, AsmCpu basedOn) {
      this.name = name;
      this.allOpcodes = new ArrayList<>();
      this.opcodesByMnemonicAddrMode = new LinkedHashMap<>();
      for(AsmOpcode opcode : basedOn.allOpcodes) {
         addOpcode(opcode);
      }
   }

   /**
    * Get a specific instruction opcode form the instruction set
    *
    * @param mnemonic The mnemonic
    * @param addressingMode The addressing mode
    * @return The opcode, if is exists. Null if the instruction set does not have the opcode.
    */
   private AsmOpcode getOpcode(String mnemonic, AsmAddressingMode addressingMode) {
      String key = mnemonic.toLowerCase() + "_" + addressingMode.getName();
      return opcodesByMnemonicAddrMode.get(key);
   }

   /**
    * Add an instruction opcode to the instruction set.
    *
    * @param opcode The numeric opcode
    * @param mnemonic The lower case mnemonic
    * @param addressingMode The addressing mode
    * @param cycles The number of cycles
    */
   protected void addOpcode(int opcode, String mnemonic, AsmAddressingMode addressingMode, double cycles, String clobberString) {
      AsmOpcode asmOpcode = new AsmOpcode(opcode, mnemonic, addressingMode, cycles, clobberString);
      addOpcode(asmOpcode);
   }

   /**
    * Add an instruction opcode to the instruction set.
    *
    * @param opcode The opcode to add
    */
   private void addOpcode(AsmOpcode asmOpcode) {
      allOpcodes.add(asmOpcode);
      opcodesByMnemonicAddrMode.put(asmOpcode.getMnemonic() + "_" + asmOpcode.getAddressingMode().getName(), asmOpcode);
   }

}
