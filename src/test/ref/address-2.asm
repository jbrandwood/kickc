// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem-page address - global variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label i = $2000
__bbegin:
  // i = 3
  lda #3
  sta i
  jsr main
  rts
main: {
  __b1:
    // while(i<7)
    lda i
    cmp #7
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = i
    ldy i
    tya
    sta SCREEN,y
    // SCREEN[i++] = i;
    inc i
    jmp __b1
}
