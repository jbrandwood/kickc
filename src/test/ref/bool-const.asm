// A Minimal test of boolean constants.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // bool_const_if()
    jsr bool_const_if
    // bool_const_vars()
    jsr bool_const_vars
    // bool_const_inline()
    jsr bool_const_inline
    // }
    rts
}
// A constant boolean inside an if()
bool_const_if: {
    // SCREEN[0] = 't'
    lda #'t'
    sta SCREEN
    // }
    rts
}
// A bunch of constant boolean vars (used in an if)
bool_const_vars: {
    // SCREEN[1] = 'f'
    lda #'f'
    sta SCREEN+1
    // }
    rts
}
// A constant boolean inside an if()
bool_const_inline: {
    // SCREEN[2] = 't'
    lda #'t'
    sta SCREEN+2
    // }
    rts
}
