.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  jsr main
main: {
    jsr bool_const_if
    jsr bool_const_vars
    jsr bool_const_inline
    rts
}
bool_const_inline: {
    lda #'t'
    sta SCREEN+2
    rts
}
bool_const_vars: {
    lda #'f'
    sta SCREEN+1
    rts
}
bool_const_if: {
    lda #'t'
    sta SCREEN+0
    rts
}
