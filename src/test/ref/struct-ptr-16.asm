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
    // *SCREEN = get(0)
    sta SCREEN
    stx SCREEN+OFFSET_STRUCT_POINT_Y
    ldy #1
  __b1:
    // get(i)
    tya
    jsr get
    // get(i)
    sta.z __1_x
    stx.z __1_y
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
    // if(i==0)
    cmp #0
    beq __b1
    // if(i==1)
    cmp #1
    beq __b2
    // return *p2;
    lda p2
    ldx p2+OFFSET_STRUCT_POINT_Y
    // }
    rts
  __b2:
    // return *p1;
    lda p1
    ldx p1+OFFSET_STRUCT_POINT_Y
    rts
  __b1:
    // return *p0;
    lda p0
    ldx p0+OFFSET_STRUCT_POINT_Y
    rts
}
