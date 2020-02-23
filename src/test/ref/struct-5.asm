// Minimal struct - struct return value
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // point()
    jsr point
    // SCREEN[0] = q.x
    lda #point.p_x
    sta SCREEN
    // SCREEN[1] = q.y
    lda #point.p_y
    sta SCREEN+1
    // }
    rts
}
point: {
    .label p_x = 2
    .label p_y = 3
    rts
}
