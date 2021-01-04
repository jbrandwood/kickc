  // Commodore 64 PRG executable file
.file [name="scroll-clobber.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label nxt = 2
    ldx #0
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b1:
    // c = *nxt
    ldy #0
    lda (nxt),y
    tay
    // if(c==0)
    cpy #0
    bne __b2
    // c = *nxt
    ldy TEXT
    lda #<TEXT
    sta.z nxt
    lda #>TEXT
    sta.z nxt+1
  __b2:
    // SCREEN[++i] = c;
    inx
    // SCREEN[++i] = c
    tya
    sta SCREEN,x
    // nxt++;
    inc.z nxt
    bne !+
    inc.z nxt+1
  !:
    jmp __b1
}
.segment Data
  TEXT: .text "01234567"
  .byte 0
