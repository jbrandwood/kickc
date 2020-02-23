// Minimal struct - passing struct value parameter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label p1_y = 4
    // print(p1)
    ldx #0
    lda #1
    jsr print
    // print(p1)
    lda #2
    jsr print
    // }
    rts
}
// print(byte register(A) p_x)
print: {
    // SCREEN[idx++] = p.x
    sta SCREEN,x
    // SCREEN[idx++] = p.x;
    inx
    // SCREEN[idx++] = p.y
    lda #main.p1_y
    sta SCREEN,x
    // SCREEN[idx++] = p.y;
    inx
    // }
    rts
}
