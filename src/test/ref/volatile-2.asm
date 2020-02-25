// Test that volatile const vars are turned into load/store
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label ch = 2
__bbegin:
  // ch = 3
  lda #3
  sta.z ch
  jsr main
  rts
main: {
    ldx #3
  __b1:
    // while(i<7)
    cpx #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = ch
    lda.z ch
    sta SCREEN,x
    // SCREEN[i++] = ch;
    inx
    jmp __b1
}
