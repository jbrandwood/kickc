// Test that volatile vars are turned into load/store
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label i = 2
__start: {
    // i = 3
    lda #3
    sta.z i
    jsr main
    rts
}
main: {
  __b1:
    // while(i<7)
    lda.z i
    cmp #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = i
    ldy.z i
    tya
    sta SCREEN,y
    // SCREEN[i++] = i;
    inc.z i
    jmp __b1
}
