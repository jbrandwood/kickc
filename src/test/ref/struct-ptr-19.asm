// Demonstrates problem with passing struct pointer deref as parameter to call
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
  .label idx = 2
main: {
    .label ptr = point_x
    .label point_x = 3
    .label point_y = 4
    lda #1
    sta.z point_x
    lda #2
    sta.z point_y
    ldy.z point_x
    tax
    lda #0
    sta.z idx
    jsr print
    ldy.z ptr
    ldx ptr+OFFSET_STRUCT_POINT_Y
    jsr print
    rts
}
// print(byte register(Y) p_x, byte register(X) p_y)
print: {
    tya
    ldy.z idx
    sta SCREEN,y
    iny
    txa
    sta SCREEN,y
    iny
    sty.z idx
    rts
}
