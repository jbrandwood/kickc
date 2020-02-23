.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label SCREEN = $400
main: {
    // print_cls()
    jsr print_cls
    // mode_ctrl()
    jsr mode_ctrl
    // }
    rts
}
mode_ctrl: {
  __b1:
    // before = *BORDERCOL
    lda BORDERCOL
    // if(before==$ff)
    cmp #$ff
    beq __b2
    // *BORDERCOL = 3
    lda #3
    sta BORDERCOL
    jmp __b1
  __b2:
    // *BORDERCOL = 2
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
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++)
    lda.z sc+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z sc
    cmp #<SCREEN+$3e8
    bne __b2
    // }
    rts
  __b2:
    // *sc = ' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
