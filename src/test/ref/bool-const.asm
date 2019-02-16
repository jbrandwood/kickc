.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  //  A Minimal test of boolean constants.
  .label SCREEN = $400
main: {
    jsr bool_const_if
    jsr bool_const_vars
    jsr bool_const_inline
    rts
}
//  A constant boolean inside an if()
bool_const_inline: {
    lda #'t'
    sta SCREEN+2
    rts
}
//  A bunch of constant boolean vars (used in an if)
bool_const_vars: {
    lda #'f'
    sta SCREEN+1
    rts
}
//  A constant boolean inside an if()
bool_const_if: {
    lda #'t'
    sta SCREEN
    rts
}
