// A Minimal test of boolean constants.
  // Commodore 64 PRG executable file
.file [name="bool-const.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
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
