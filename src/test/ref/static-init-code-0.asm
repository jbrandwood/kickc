// Tests static initialization code
// Currently placed outside any function scope and pushed into @begin block.
// To be put into an initializer function.
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label c1 = 2
  .label c2 = 3
_start: {
    jsr _init
    jsr main
    rts
}
_init: {
    // c1 = 'o'
    // Initialize a volatile ZP-variable (will be done in the initializer)
    lda #'o'
    sta.z c1
    // c2 = 'k'
    // Initialize another volatile ZP-variable (will be done in the initializer)
    lda #'k'
    sta.z c2
    rts
}
main: {
    // SCREEN[0] = c1
    lda.z c1
    sta SCREEN
    // SCREEN[1] = c2
    lda.z c2
    sta SCREEN+1
    // }
    rts
}
