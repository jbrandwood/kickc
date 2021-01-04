// Tests creating and assigning pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-2.prg", type="prg", segments="Program"]
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
    // i&1
    txa
    and #1
    // if((i&1)==0)
    cmp #0
    // for ( byte i: 0..100)
    inx
    cpx #$65
    bne __b1
    // }
    rts
}
