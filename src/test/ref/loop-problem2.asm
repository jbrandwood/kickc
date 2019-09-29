.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label SCREEN = $400
main: {
    jsr print_cls
    jsr mode_ctrl
    rts
}
mode_ctrl: {
  __b1:
    lda BORDERCOL
    cmp #$ff
    beq __b2
    lda #3
    sta BORDERCOL
    jmp __b1
  __b2:
    lda #2
    sta BORDERCOL
    jmp __b1
}
print_cls: {
    .label sc = 2
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z sc
    cmp #<SCREEN+$3e8
    bne __b2
    rts
  __b2:
    lda #' '
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
