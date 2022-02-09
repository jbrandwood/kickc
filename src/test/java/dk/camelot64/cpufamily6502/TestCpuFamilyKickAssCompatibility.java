package dk.camelot64.cpufamily6502;

import dk.camelot64.cpufamily6502.cpus.*;
import kickass._65xx._65xxArgType;
import kickass._65xx.cpus.*;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.*;


public class TestCpuFamilyKickAssCompatibility {

   @Test
   public void testOpcodes6502Official() {
      assertOpcodesMatch(Cpu6502Official.INSTANCE, CPU_6502NoIllegals.instance);
   }

   @Test
   public void testOpcodes6502Illegal() {
      assertOpcodesMatch(Cpu6502Illegal.INSTANCE, CPU_6502WithIllegals.instance);
   }

   @Test
   public void testOpcodes65C02() {
      assertOpcodesMatch(Cpu65C02.INSTANCE, CPU_65C02.instance);
   }

   @Test
   public void testOpcodes65CE02() {
      assertOpcodesMatch(Cpu65CE02.INSTANCE, CPU_65CE02.instance);
   }

   @Test
   public void testOpcodesHuc6280() {
      assertOpcodesMatch(CpuHuc6280.INSTANCE, CPU_HUC6280.instance);
   }

   @Test
   public void testOpcodes45GS02() {
      assertOpcodesMatch(Cpu45GS02.INSTANCE, CPU_45GS02.instance);
   }

   private void assertOpcodesMatch(Cpu65xx kcCpu, Cpu kaCpu) {
      final Collection<CpuOpcode> kcAllOpcodes = kcCpu.getAllOpcodes();
      final List<MnemonicDefinition> kaAllMnemonics = kaCpu.mnemonics;
      final Map<CpuAddressingMode, List<_65xxArgType>> kaAddressingModeMap = getKAAddressingModeMap();

      // Test that each KickC opcode has a matching KickAss opcode
      for(CpuOpcode kcOpcode : kcAllOpcodes) {

         int[] kaOpcodes = null;
         for(MnemonicDefinition kaMnemonic : kaAllMnemonics) {
            for(String kaName : kaMnemonic.namesList) {
               if(kaName.equals(kcOpcode.getMnemonic())) {
                  kaOpcodes = kaMnemonic.opcodes;
               }
            }
         }

         // final int[] kaOpcodes = kaAllMnemonics.get(kcOpcode.getMnemonic());

         assertNotNull(kcOpcode.getMnemonic(), "KickAss CPU " + kaCpu.name + " does not know the KickC CPU " + kcCpu.getName() + " mnemonic");
         final List<_65xxArgType> kaArgTypes = kaAddressingModeMap.get(kcOpcode.getAddressingMode());
         assertNotNull(kaArgTypes, "KickAss addressing mode not found " + kcOpcode.getAddressingMode().getName());
         // Try each argtype to find the one that works
         boolean found = false;
         for(_65xxArgType kaArgType : kaArgTypes) {
            final int kaArgTypeIdx = kaArgType.getIdNo();
            if(kaOpcodes != null && kaOpcodes.length > kaArgTypeIdx) {
               final int kaOpcodeRaw = kaOpcodes[kaArgTypeIdx];
               if(kaOpcodeRaw >= 0) {
                  found = true;
                  int[] kaOpcode = getKAOpcode(kaOpcodeRaw, kaArgType, kcOpcode.getMnemonic());
                  assertArrayEquals(kcOpcode.getOpcode(), kaOpcode, "KickAss opcode not matching for mnemonic " + kcOpcode.toString());

                  int kaByteSize = kaOpcode.length + kaArgType.getByteSize();
                  assertEquals(kcOpcode.getBytes(), kaByteSize, "KickAss opcode byte size not matching KickC byte size "+kcOpcode.toString());
               }
            }
         }
         if(!found)
            System.out.println("Not found!");
         assertTrue(found, "KickAss opcode not found for mnemonic " + kcOpcode.toString());
      }

      // Test that each KickAss opcode has a matching KickC opcode


   }

   /**
    * Convert KickAssembler opcode to int array, that also contains the prefix opcodes used by 45GS02.
    *
    * @param kaOpcodeRaw The "raw" one-byte opcode
    * @param kaArgType The addressing mode
    * @param mnemonic The instruction mnemonic
    * @return The opcode list.
    */
   private int[] getKAOpcode(int kaOpcodeRaw, _65xxArgType kaArgType, String mnemonic) {
      List<Integer> kaOpcodeList = new ArrayList<>();
      if(CPU_45GS02.R32_MNEMONICS.contains(mnemonic)) {
         // Make sure the prefix is unsigned
         kaOpcodeList.add((int) CPU_45GS02.R32_OPCODE_PREFIX & 0xff);
         kaOpcodeList.add((int) CPU_45GS02.R32_OPCODE_PREFIX & 0xff);
      }
      if(kaArgType == _65xxArgType.indirect32ZeropageZ || kaArgType == _65xxArgType.indirect32Zeropage) {
         // Make sure the prefix is unsigned
         kaOpcodeList.add(CPU_45GS02.A32_OPCODE_PREFIX & 0xff);
      }
      kaOpcodeList.add(kaOpcodeRaw);
      int[] kaOpcode = kaOpcodeList.stream().mapToInt(i -> i).toArray();
      return kaOpcode;
   }

   /**
    * Get the KickAss ArgType that matches a KickC addressing mode.
    *
    * @return The argtype.
    */
   Map<CpuAddressingMode, List<_65xxArgType>> getKAAddressingModeMap() {
      final HashMap<CpuAddressingMode, List<_65xxArgType>> map = new HashMap<>();
      map.put(CpuAddressingMode.NON, Collections.singletonList(_65xxArgType.noArgument));
      map.put(CpuAddressingMode.IMM, Collections.singletonList(_65xxArgType.immediate));
      map.put(CpuAddressingMode.IMW, Collections.singletonList(_65xxArgType.immediateWord));
      map.put(CpuAddressingMode.ZP, Collections.singletonList(_65xxArgType.zeropage));
      map.put(CpuAddressingMode.ZPX, Collections.singletonList(_65xxArgType.zeropageX));
      map.put(CpuAddressingMode.ZPY, Collections.singletonList(_65xxArgType.zeropageY));
      map.put(CpuAddressingMode.ABS, Collections.singletonList(_65xxArgType.absolute));
      map.put(CpuAddressingMode.ABX, Collections.singletonList(_65xxArgType.absoluteX));
      map.put(CpuAddressingMode.ABY, Collections.singletonList(_65xxArgType.absoluteY));
      map.put(CpuAddressingMode.IZX, Collections.singletonList(_65xxArgType.indirectZeropageX));
      map.put(CpuAddressingMode.IAX, Collections.singletonList(_65xxArgType.indirectX));
      map.put(CpuAddressingMode.IZY, Collections.singletonList(_65xxArgType.indirectZeropageY));
      map.put(CpuAddressingMode.IZZ, Collections.singletonList(_65xxArgType.indirectZeropageZ));
      map.put(CpuAddressingMode.IND, Collections.singletonList(_65xxArgType.indirect));
      map.put(CpuAddressingMode.INZ, Collections.singletonList(_65xxArgType.indirectZeropage));
      map.put(CpuAddressingMode.LIN, Collections.singletonList(_65xxArgType.indirect32Zeropage));
      map.put(CpuAddressingMode.LIZ, Collections.singletonList(_65xxArgType.indirect32ZeropageZ));
      map.put(CpuAddressingMode.ISY, Collections.singletonList(_65xxArgType.indirectStackZeropageY));
      map.put(CpuAddressingMode.REL, Arrays.asList(_65xxArgType.relative, _65xxArgType.relativeWord));
      map.put(CpuAddressingMode.REZ, Collections.singletonList(_65xxArgType.zeropageRelative));
      map.put(CpuAddressingMode.IMMANDZP, Collections.singletonList(_65xxArgType.immediateAndZeropage));
      map.put(CpuAddressingMode.IMMANDABS, Collections.singletonList(_65xxArgType.immediateAndAbsolute));
      return map;
   }


   // map.entrySet().stream().collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey))

}
