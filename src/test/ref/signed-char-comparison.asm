// Illustrates problem with > comparison of signed chars.
// Reported by Danny Spijksma
  // Commodore 64 PRG executable file
.file [name="signed-char-comparison.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #-$80
  __b1:
    // debug(dy)
    jsr debug
    // for(signed char dy:-128..127)
    inx
    cpx #-$80
    bne __b1
    // }
    rts
}
// debug(signed byte register(X) dy)
debug: {
    // if (dy > -120)
    txa
    sec
    sbc #-$78
    beq __breturn
    bvc !+
    eor #$80
  !:
    bmi __breturn
    // SCREEN[i] = 10
    lda #$a
    sta SCREEN,x
  __breturn:
    // }
    rts
}
