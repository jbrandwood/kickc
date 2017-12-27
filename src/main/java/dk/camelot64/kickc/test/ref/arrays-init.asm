.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  b: .fill 3, 0
  c: .byte 'c', 'm', 'l'
  d: .text "cml"
  jsr main
main: {
    lda #'c'
    sta b+0
    sta SCREEN
    lda c+1
    sta SCREEN+1
    lda d+2
    sta SCREEN+2
    rts
}
