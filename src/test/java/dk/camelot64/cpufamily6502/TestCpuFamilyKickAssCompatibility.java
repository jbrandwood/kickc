package dk.camelot64.cpufamily6502;

import dk.camelot64.cpufamily6502.cpus.Cpu6502Illegal;
import dk.camelot64.cpufamily6502.cpus.Cpu6502Official;
import dk.camelot64.cpufamily6502.cpus.Cpu65C02;
import dk.camelot64.cpufamily6502.cpus.Cpu65CE02;
import kickass._65xx._65xxArgType;
import kickass._65xx.cpus.*;
import org.junit.Assert;
import org.junit.Test;

import java.util.*;

import static junit.framework.TestCase.assertNotNull;
import static junit.framework.TestCase.assertTrue;

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

   private void assertOpcodesMatch(Cpu65xx kcCpu, Cpu kaCpu) {
      final Collection<CpuOpcode> kcAllOpcodes = kcCpu.getAllOpcodes();
      final Map<String, int[]> kaAllMnemonics = kaCpu.mnemonics;
      final Map<CpuAddressingMode, List<_65xxArgType>> kaAddressingModeMap = getKAAddressingModeMap();

      // Test that each KickC opcode has a matching KickAss opcode
      for(CpuOpcode kcOpcode : kcAllOpcodes) {
         final int[] kaOpcodes = kaAllMnemonics.get(kcOpcode.getMnemonic());
         assertNotNull("KickAss CPU " + kaCpu.name + " does not know the KickC CPU " + kcCpu.getName() + " mnemonic", kcOpcode.getMnemonic());
         final List<_65xxArgType> kaArgTypes = kaAddressingModeMap.get(kcOpcode.getAddressingMode());
         assertNotNull("KickAss addressing mode not found " + kcOpcode.getAddressingMode().getName(), kaArgTypes);
         // Try each argtype
         boolean found = false;
         for(_65xxArgType kaArgType : kaArgTypes) {
            final int kaArgTypeIdx = kaArgType.getIdNo();
            if(kaOpcodes!=null && kaOpcodes.length>kaArgTypeIdx) {
               final int kaOpcodeRaw = kaOpcodes[kaArgTypeIdx];
               if(kaOpcodeRaw >= 0) {
                  found = true;
                  final int[] kaOpcode = new int[]{kaOpcodeRaw};
                  Assert.assertArrayEquals("KickAss opcode not matching for mnemonic " + kcOpcode.toString(), kcOpcode.getOpcode(), kaOpcode);
               }
            }
         }
         assertTrue("KickAss opcode not found for mnemonic " + kcOpcode.toString(), found);
      }

   }

   /**
    * Get the KickAss ArgType that matches a KickC addressing mode.
    * @return The argtype.
    */
   Map<CpuAddressingMode, List<_65xxArgType>> getKAAddressingModeMap() {
      final HashMap<CpuAddressingMode, List<_65xxArgType>> map = new HashMap<>();
      map.put(CpuAddressingMode.NON, Collections.singletonList(_65xxArgType.noArgument));
      map.put(CpuAddressingMode.IMM, Arrays.asList(_65xxArgType.immediate, _65xxArgType.immediateWord));
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
      // TODO: Handle Immediate Word, relative Word
      return map;
   }


   // map.entrySet().stream().collect(Collectors.toMap(Map.Entry::getValue, Map.Entry::getKey))

}
