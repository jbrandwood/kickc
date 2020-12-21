// Clobber problem in next_char return value
  // Commodore 64 PRG executable file
.file [name="scrollbig-clobber.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label nxt = 3
.segment Code
main: {
    .label SCREEN = $400
    .label i = 2
    lda #0
    sta.z i
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // next_char()
    jsr next_char
    txa
    // SCREEN[i] = next_char()
    ldy.z i
    sta SCREEN,y
    // for( byte i: 0..255)
    inc.z i
    lda.z i
    cmp #0
    bne __b1
    // }
    rts
}
// Find the next char of the text
next_char: {
    // c = *nxt
    ldy #0
    lda (nxt),y
    tax
    // if(c==0)
    cpx #0
    bne __b1
    // c = *nxt
    ldx TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // nxt++;
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    // }
    rts
}
.segment Data
  TEXT: .text "cml "
  .byte 0
