// Tests static initialization code
// Currently placed outside any function scope and pushed into @begin block.
// To be put into an initializer function.
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label c1 = 2
  .label c2 = 3
__bbegin:
  // c1 = 'x'
  // Initialize a volatile ZP-variable (will be done in the initializer)
  lda #'x'
  sta.z c1
  // c2 = SCREEN>1000?'s':'m'
  // Initialize another volatile ZP-variable (will be done in the initializer)
  lda #'s'
  sta.z c2
  jsr main
  rts
main: {
    // SCREEN[0] = c1
    lda.z c1
    sta SCREEN
    // SCREEN[0] = c2
    lda.z c2
    sta SCREEN
    // }
    rts
}
