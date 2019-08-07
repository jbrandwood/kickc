// Test address-of - pass the pointer as parameter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label b1 = 4
    .label b2 = 5
    .label b3 = 6
    lda #0
    sta.z b1
    sta.z b2
    sta.z b3
    lda #<b1
    sta.z setByte.ptr
    lda #>b1
    sta.z setByte.ptr+1
    ldx #'c'
    jsr setByte
    lda #<b2
    sta.z setByte.ptr
    lda #>b2
    sta.z setByte.ptr+1
    ldx #'m'
    jsr setByte
    lda #<b3
    sta.z setByte.ptr
    lda #>b3
    sta.z setByte.ptr+1
    ldx #'l'
    jsr setByte
    lda.z b1
    sta SCREEN
    lda.z b2
    sta SCREEN+1
    lda.z b3
    sta SCREEN+2
    rts
}
// setByte(byte* zeropage(2) ptr, byte register(X) b)
setByte: {
    .label ptr = 2
    txa
    ldy #0
    sta (ptr),y
    rts
}
