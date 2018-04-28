.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label screen = $400
    lda #'c'
    sta screen+0
    sta screen+$28
    lda #'m'
    sta screen+1
    sta screen+$29
    lda #1+'l'
    sta screen+2
    lda #'l'
    sta screen+$2a
    rts
}
