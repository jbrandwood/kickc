// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem address - local variable
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = $2000
    // i = 3
    lda #3
    sta i
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
