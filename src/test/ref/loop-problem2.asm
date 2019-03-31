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
  b1:
    lda BORDERCOL
    cmp #$ff
    beq b2
    lda #3
    sta BORDERCOL
    jmp b1
  b2:
    lda #2
    sta BORDERCOL
    jmp b1
}
print_cls: {
    .label sc = 2
    lda #<SCREEN
    sta sc
    lda #>SCREEN
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
    cmp #>SCREEN+$3e8
    bne b1
    lda sc
    cmp #<SCREEN+$3e8
    bne b1
    rts
}
