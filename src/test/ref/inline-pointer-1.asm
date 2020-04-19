// Tests creating a literal pointer from two bytes
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // puta(4, 0x00)
    ldx #0
    lda #4
    jsr puta
    // puta(5, 0x18)
    ldx #$18
    lda #5
    jsr puta
    // }
    rts
}
// puta(byte register(A) ph, byte register(X) pl)
puta: {
    .label screen = 2
    // screen = (byte*) { ph, pl }
    sta.z screen+1
    stx.z screen
    // *screen = 'a'
    lda #'a'
    ldy #0
    sta (screen),y
    // }
    rts
}
