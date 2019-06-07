// Minimal struct - passing struct value parameter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label p1_y = 4
    ldx #0
    lda #1
    jsr print
    lda #2
    jsr print
    rts
}
// print(byte register(A) p_x)
print: {
    sta SCREEN,x
    inx
    lda #main.p1_y
    sta SCREEN,x
    inx
    rts
}
