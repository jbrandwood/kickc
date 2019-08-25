// Test rewriting of constant comparisons
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label sc = 2
    .label screen = 4
    lda #<$400
    sta.z sc
    lda #>$400
    sta.z sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>$400+$3e8+1
    bne b1
    lda.z sc
    cmp #<$400+$3e8+1
    bne b1
    ldx #0
  b2:
    lda header,x
    cmp #0
    bne b3
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  b4:
    cpx #9+1
    bcc b5
    rts
  b5:
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    txa
    clc
    adc #'0'
    ldy #0
    sta (screen),y
    cpx #5
    bcs b6
    lda #'+'
    ldy #2
    sta (screen),y
  b6:
    cpx #5+1
    bcs b7
    lda #'+'
    ldy #5
    sta (screen),y
  b7:
    cpx #5
    bne b8
    lda #'+'
    ldy #8
    sta (screen),y
  b8:
    cpx #5
    bcc b9
    lda #'+'
    ldy #$b
    sta (screen),y
  b9:
    cpx #5+1
    bcc b10
    lda #'+'
    ldy #$e
    sta (screen),y
  b10:
    inx
    jmp b4
  b3:
    lda header,x
    sta $400,x
    inx
    jmp b2
    header: .text "  <  <= == >= >"
    .byte 0
}
