// Fill screen using a pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label dst = 2
    lda #<SCREEN
    sta.z dst
    lda #>SCREEN
    sta.z dst+1
  __b1:
    // for(char* dst = SCREEN; dst!=SCREEN + 1000; dst++)
    lda.z dst+1
    cmp #>SCREEN+$3e8
    bne __b2
    lda.z dst
    cmp #<SCREEN+$3e8
    bne __b2
    // }
    rts
  __b2:
    // *dst = ' '
    lda #' '
    ldy #0
    sta (dst),y
    // for(char* dst = SCREEN; dst!=SCREEN + 1000; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
