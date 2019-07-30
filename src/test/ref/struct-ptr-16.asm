// Demonstrates problem with returning a dereferenced pointer to a struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
  .label p0 = $a000
  .label p1 = $b000
  .label p2 = $e000
main: {
    .label _1_x = 3
    .label _1_y = 4
    lda #0
    jsr get
    lda get.return_y
    stx SCREEN
    sta SCREEN+OFFSET_STRUCT_POINT_Y
    ldy #1
  b1:
    tya
    jsr get
    lda get.return_y
    stx _1_x
    sta _1_y
    tya
    asl
    tax
    lda _1_x
    sta SCREEN,x
    lda _1_y
    sta SCREEN+OFFSET_STRUCT_POINT_Y,x
    iny
    cpy #3
    bne b1
    rts
}
// get(byte register(A) i)
get: {
    .label return_y = 2
    cmp #0
    beq b1
    cmp #1
    beq b2
    ldx p2
    lda p2+OFFSET_STRUCT_POINT_Y
    sta return_y
    rts
  b2:
    ldx p1
    lda p1+OFFSET_STRUCT_POINT_Y
    sta return_y
    rts
  b1:
    ldx p0
    lda p0+OFFSET_STRUCT_POINT_Y
    sta return_y
    rts
}
