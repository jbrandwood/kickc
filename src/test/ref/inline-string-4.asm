// Test casting the address of an inline string to a dword.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label dw = msg
    jsr output
    rts
    msg: .text "camelot"
    .byte 0
}
output: {
    lda #<main.dw
    sta screen
    lda #>main.dw
    sta screen+1
    lda #<main.dw>>$10
    sta screen+2
    lda #>main.dw>>$10
    sta screen+3
    rts
}
