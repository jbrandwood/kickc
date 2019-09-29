// Test parsing a negated struct reference - which causes problems with the ASMREL labels !a++
// https://gitlab.com/camelot/kickc/issues/266
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label aa_b = 2
__bbegin:
  lda #1
  sta.z aa_b
  jsr main
  rts
main: {
    .label SCREEN = $400
    .label a = aa_b
    lda #0
    cmp.z a
    bne !a+
    lda #'a'
    sta SCREEN
    // ASMREL labels
    jmp !a+
  !a:
    rts
}
