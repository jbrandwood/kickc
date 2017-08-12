  jsr main
main: {
    ldx #$0
    jsr inccnt
    stx $400
    inx
    jsr inccnt
    inx
    stx $401
    rts
}
inccnt: {
    inx
    rts
}
