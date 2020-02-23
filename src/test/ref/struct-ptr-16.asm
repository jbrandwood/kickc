// Demonstrates problem with returning a dereferenced pointer to a struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const OFFSET_STRUCT_POINT_Y = 1
  .label p0 = $a000
  .label p1 = $b000
  .label p2 = $e000
main: {
    .label __1_x = 2
    .label __1_y = 3
    // get(0)
    lda #0
    jsr get
    // get(0)
    lda.z get.return_y
    // *SCREEN = get(0)
    stx SCREEN
    sta SCREEN+OFFSET_STRUCT_POINT_Y
    ldy #1
  __b1:
    // get(i)
    tya
    jsr get
    // get(i)
    lda.z get.return_y
    stx.z __1_x
    sta.z __1_y
    // SCREEN[i] = get(i)
    tya
    asl
    tax
    lda.z __1_x
    sta SCREEN,x
    lda.z __1_y
    sta SCREEN+OFFSET_STRUCT_POINT_Y,x
    // for ( char i: 1..2)
    iny
    cpy #3
    bne __b1
    // }
    rts
}
// get(byte register(A) i)
get: {
    .label return_y = 2
    // if(i==0)
    cmp #0
    beq __b1
    // if(i==1)
    cmp #1
    beq __b2
    // return *p2;
    ldx p2
    lda p2+OFFSET_STRUCT_POINT_Y
    sta.z return_y
    // }
    rts
  __b2:
    // return *p1;
    ldx p1
    lda p1+OFFSET_STRUCT_POINT_Y
    sta.z return_y
    rts
  __b1:
    // return *p0;
    ldx p0
    lda p0+OFFSET_STRUCT_POINT_Y
    sta.z return_y
    rts
}
