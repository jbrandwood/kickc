// Test that address vars are turned into load/store and located at hardcoded addresses
// Hard-coded mainmem-page address - global variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label i = $2000
__bbegin:
  lda #3
  sta i
  jsr main
  rts
main: {
  __b1:
    lda i
    cmp #7
    bcc __b2
    rts
  __b2:
    ldy i
    tya
    sta SCREEN,y
    inc i
    jmp __b1
}
