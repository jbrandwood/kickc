.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    lda #'c'
    sta b
    sta SCREEN
    lda c+1
    sta SCREEN+1
    lda d+2
    sta SCREEN+2
    rts
}
  d: .text "cml"
  b: .fill 3, 0
  c: .byte 'c', 'm', 'l'
