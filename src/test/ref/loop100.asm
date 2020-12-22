  // Commodore 64 PRG executable file
.file [name="loop100.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    ldx #0
  __b1:
    // for(byte i=0; i<100; i++)
    cpx #$64
    bcc __b2
    // }
    rts
  __b2:
    // for(byte i=0; i<100; i++)
    inx
    jmp __b1
}
