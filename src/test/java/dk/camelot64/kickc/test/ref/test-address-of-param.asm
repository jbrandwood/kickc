.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    .label b1 = 4
    .label b2 = 5
    .label b3 = 6
    lda #0
    sta b1
    sta b2
    sta b3
    lda #<b1
    sta setByte.ptr
    lda #>b1
    sta setByte.ptr+1
    ldx #'c'
    jsr setByte
    lda #<b2
    sta setByte.ptr
    lda #>b2
    sta setByte.ptr+1
    ldx #'m'
    jsr setByte
    lda #<b3
    sta setByte.ptr
    lda #>b3
    sta setByte.ptr+1
    ldx #'l'
    jsr setByte
    lda b1
    sta SCREEN
    lda b2
    sta SCREEN+1
    lda b3
    sta SCREEN+2
    rts
}
setByte: {
    .label ptr = 2
    txa
    ldy #0
    sta (ptr),y
    rts
}
