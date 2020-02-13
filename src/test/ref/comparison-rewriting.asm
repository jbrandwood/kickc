// Test rewriting of constant comparisons
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label sc = 2
    .label screen = 4
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>SCREEN+$3e8+1
    bne __b1
    lda.z sc
    cmp #<SCREEN+$3e8+1
    bne __b1
    ldx #0
  __b2:
    lda header,x
    cmp #0
    bne __b3
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
    ldx #0
  __b4:
    cpx #9+1
    bcc __b5
    rts
  __b5:
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
    bcs __b6
    lda #'+'
    ldy #2
    sta (screen),y
  __b6:
    cpx #5+1
    bcs __b7
    lda #'+'
    ldy #5
    sta (screen),y
  __b7:
    cpx #5
    bne __b8
    lda #'+'
    ldy #8
    sta (screen),y
  __b8:
    cpx #5
    bcc __b9
    lda #'+'
    ldy #$b
    sta (screen),y
  __b9:
    cpx #5+1
    bcc __b10
    lda #'+'
    ldy #$e
    sta (screen),y
  __b10:
    inx
    jmp __b4
  __b3:
    lda header,x
    sta SCREEN,x
    inx
    jmp __b2
    header: .text "  <  <= == >= >"
    .byte 0
}
