package dk.camelot64.cpufamily6502.cpus;

import dk.camelot64.cpufamily6502.Cpu65xx;
import dk.camelot64.cpufamily6502.CpuAddressingMode;

/**
 * The HUC6280 instruction set.
 * https://www.chrismcovell.com/PCEdev/HuC6280_opcodes.html
 * http://shu.emuunlim.com/download/pcedocs/pce_cpu.html
 */
public class CpuHuc6280 extends Cpu65xx {

    /** The HUC6280 CPU name. */
    public final static String NAME = "huc6280";

    /** The HUC6280 CPU. */
    public final static CpuHuc6280 INSTANCE = new CpuHuc6280();

    public CpuHuc6280() {
        super(NAME, Cpu65C02.INSTANCE, false);

        // The following instructions are not supported yet:
        // TST #imm, zp
        // TST #imm, zp,x
        // TST #imm, abs
        // TST #imm, abs,x
        // TII SHSL,DHDL, LHLL
        // TIN SHSL,DHDL, LHLL
        // TDD SHSL,DHDL, LHLL
        // TIA SHSL,DHDL, LHLL
        // TAI SHSL,DHDL, LHLL

        addOpcode(0x02,"sxy", CpuAddressingMode.NON,3,"XY");
        addOpcode(0x03,"st0", CpuAddressingMode.IMM,4,"");
        addOpcode(0x13,"st1", CpuAddressingMode.IMM,4,"");
        addOpcode(0x22,"sax", CpuAddressingMode.NON,3,"AX");
        addOpcode(0x23,"st2", CpuAddressingMode.IMM,4,"");
        addOpcode(0x42,"say", CpuAddressingMode.NON,3,"AY");
        addOpcode(0x43,"tma", CpuAddressingMode.IMM,4,"A");
        addOpcode(0x44,"bsr", CpuAddressingMode.REL,8,"PS");
        addOpcode(0x53,"tam", CpuAddressingMode.IMM,5,"");
        addOpcode(0x54,"csl", CpuAddressingMode.NON,2,"");
        addOpcode(0x62,"cla", CpuAddressingMode.NON,2,"A");
        addOpcode(0x82,"clx", CpuAddressingMode.NON,2,"X");
        addOpcode(0xc2,"cly", CpuAddressingMode.NON,2,"Y");
        addOpcode(0xd4,"csh", CpuAddressingMode.NON,2,"");
        addOpcode(0xf4,"set", CpuAddressingMode.NON,2,"");
    }

}
