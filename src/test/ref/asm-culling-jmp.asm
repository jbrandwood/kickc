// Example of inline ASM where a JMP is erronously culled during compilation
// https://gitlab.com/camelot/kickc/issues/302
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jmp qwe
    .byte 0, 25, 51, 76, 102, 128, 153, 179, 204, 230
  qwe:
    lda #$32
    lda #'c'
    sta $400
    rts
}
