  jsr main
main: {
    ldy #$0
    ldx #$0
    jsr inccnt
    sta $400
    inx
    jsr inccnt
    sta $401
    rts
}
inccnt: {
    inx
    iny
    txa
    rts
}
