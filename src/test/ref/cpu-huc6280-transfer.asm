// Tests the HUC6280 instructions
.cpu _huc6280
  // Commodore 64 PRG executable file
.file [name="cpu-huc6280-transfer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // asm
    tia 1,2,3
    tdd $1000,$2000,$800
    tii $1000+4*8,$2000+4*8,$800+4*8
    tin SCREEN,$2000,$28*$18
    rts
    // }
}
