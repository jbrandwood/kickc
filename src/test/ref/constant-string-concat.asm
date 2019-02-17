// Concatenates string constants in different ways
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  b1:
    lda s5,x
    sta SCREEN,x
    inx
    cpx #8
    bne b1
    rts
    s: .text "e"+"l"
    s4: .text ""+'t'+'!'
    s3: .text "cam"+s+'o'
    s5: .text s3+s4
}
