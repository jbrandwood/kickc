// Tests the HUC6280 instructions
.cpu _huc6280
  // Commodore 64 PRG executable file
.file [name="cpu-huc6280-tst.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // asm
    tst.z #1+2,3+4
    tst #1+2*3,$7654/2
    tst.z #1+2,3+4,x
    tst #1+2*3,$7654/2,x
  !:
    rts
    // }
}
