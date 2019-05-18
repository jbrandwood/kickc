// Tests creating a literal pointer from two bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
    lda #4
    jsr puta
    ldx #$18
    lda #5
    jsr puta
    rts
}
// puta(byte register(A) ph, byte register(X) pl)
puta: {
    .label screen = 2
    .label _2 = 2
    sta _2+1
    stx _2
    lda #'a'
    ldy #0
    sta (screen),y
    rts
}