  // Commodore 64 PRG executable file
.file [name="bitwise-not.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = ~1ub
    lda #1^$ff
    sta SCREEN
    ldx #1
  __b1:
    // ~c
    txa
    eor #$ff
    // SCREEN[c] = ~c
    sta SCREEN,x
    // for(byte c : 1..26)
    inx
    cpx #$1b
    bne __b1
    // }
    rts
}
