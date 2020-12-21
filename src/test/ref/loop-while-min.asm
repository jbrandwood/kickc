// Minimal classic while() loop
  // Commodore 64 PRG executable file
.file [name="loop-while-min.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
  __b1:
    // while(i!=100)
    cpx #$64
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    txa
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
}
