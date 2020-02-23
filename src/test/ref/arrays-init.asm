.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // b[0] = 'c'
    lda #'c'
    sta b
    // *SCREEN = b[0]
    sta SCREEN
    // *(SCREEN+1) = c[1]
    lda c+1
    sta SCREEN+1
    // *(SCREEN+2) = d[2]
    lda d+2
    sta SCREEN+2
    // }
    rts
}
  b: .fill 3, 0
  c: .byte 'c', 'm', 'l'
  d: .text "cml"
