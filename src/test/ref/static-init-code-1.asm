// Tests static initialization code
// No initialization code should call main() directly removing _start() and _init()
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = 'o'
    lda #'o'
    sta SCREEN
    // SCREEN[1] = 'k'
    lda #'k'
    sta SCREEN+1
    // }
    rts
}
