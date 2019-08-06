// Test rewriting of constant comparisons
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label sc = 2
    .label screen = 4
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8+1
    bne b1
    lda sc
    cmp #<$400+$3e8+1
    bne b1
    ldx #0
  b2:
    lda header,x
    sta $400,x
    inx
    lda header,x
    cmp #0
    bne b2
    lda #'0'
    sta $400+$28
    lda #<$400+$28
    sta screen
    lda #>$400+$28
    sta screen+1
    ldx #0
  b9:
    lda #'+'
    ldy #2
    sta (screen),y
  b4:
    cpx #5+1
    bcs b5
    lda #'+'
    ldy #5
    sta (screen),y
  b5:
    cpx #5
    bne b6
    lda #'+'
    ldy #8
    sta (screen),y
  b6:
    cpx #5
    bcc b7
    lda #'+'
    ldy #$b
    sta (screen),y
  b7:
    cpx #5+1
    bcc b8
    lda #'+'
    ldy #$e
    sta (screen),y
  b8:
    inx
    cpx #9+1
    bcc b3
    rts
  b3:
    lda #$28
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    txa
    clc
    adc #'0'
    ldy #0
    sta (screen),y
    cpx #5
    bcs b4
    jmp b9
    header: .text "  <  <= == >= >@"
}
