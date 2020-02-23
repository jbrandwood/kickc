// Tests continue statement in a simple for()-loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #0
  __b1:
    // for( char i =0; MESSAGE[i]; i++)
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // if(MESSAGE[i]==' ')
    lda MESSAGE,x
    cmp #' '
    beq __b4
    // SCREEN[idx++] = MESSAGE[i]
    lda MESSAGE,x
    sta SCREEN,y
    // SCREEN[idx++] = MESSAGE[i];
    iny
  __b4:
    // for( char i =0; MESSAGE[i]; i++)
    inx
    jmp __b1
}
  MESSAGE: .text "hello brave new world!"
  .byte 0
