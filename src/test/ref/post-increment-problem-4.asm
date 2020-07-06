// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label s = 2
    ldx #0
    lda #<MESSAGE
    sta.z s
    lda #>MESSAGE
    sta.z s+1
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = c
    sta SCREEN,x
    // SCREEN[i++] = c;
    inx
    jmp __b1
}
  MESSAGE: .text "hello world!"
  .byte 0
