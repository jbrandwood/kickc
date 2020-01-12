// Test parsing a negated struct reference - which causes problems with the ASMREL labels !a++
// https://gitlab.com/camelot/kickc/issues/266
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label a = aa
    lda #0
    cmp a
    bne !a+
    lda #'a'
    sta SCREEN
    // ASMREL labels
    jmp !a+
  !a:
    rts
}
  aa: .byte 1
