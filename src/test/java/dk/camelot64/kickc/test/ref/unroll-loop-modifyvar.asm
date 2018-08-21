.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    lda #3
    sta SCREEN+3
    lda #3+1
    sta SCREEN+3+1
    lda #3+1+1
    sta SCREEN+3+1+1
    lda #3+1+1+1
    sta SCREEN+3+1+1+1
    lda #3+1+1+1+1
    sta SCREEN+3+1+1+1+1
    lda #3+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1
    lda #3+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1
    lda #3+1+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1+1
    lda #3+1+1+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1+1+1
    lda #3+1+1+1+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1+1+1+1
    lda #3+1+1+1+1+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1+1+1+1+1
    lda #3+1+1+1+1+1+1+1+1+1+1+1
    sta SCREEN+3+1+1+1+1+1+1+1+1+1+1+1
    rts
}
