  // Commodore 64 PRG executable file
.file [name="inline-assignment.prg", type="prg", segments="Program"]
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
    // SCREEN[i] = a = i
    txa
    sta SCREEN,x
    // (SCREEN+80)[i] = a
    txa
    sta SCREEN+$50,x
    // for( byte i : 0..39)
    inx
    cpx #$28
    bne __b1
    // }
    rts
}
