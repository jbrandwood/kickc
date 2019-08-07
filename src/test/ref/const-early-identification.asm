// Tests that constants are identified early
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label A = 2
bbegin:
  // Not an early constant (address-of is used)
  lda #'a'
  sta.z A
  jsr main
  rts
main: {
    .const B = 'b'
    .label addrA = A
    lda.z A
    sta SCREEN
    lda #B
    sta SCREEN+1
    lda addrA
    sta SCREEN+2
    jsr sub
    rts
}
sub: {
    .const C = 'c'
    lda #C
    sta SCREEN+3
    ldx.z A
    inx
    stx SCREEN+4
    rts
}
