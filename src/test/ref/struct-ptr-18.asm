// Demonstrates problem with passing struct array element as parameter to call
  // Commodore 64 PRG executable file
.file [name="struct-ptr-18.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    // points[0] = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta points-1,y
    dey
    bne !-
    // points[1] = { 3, 4 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __1-1,y
    sta points+1*SIZEOF_STRUCT_POINT-1,y
    dey
    bne !-
    ldx #0
    txa
    sta.z i
  __b1:
    // print(points[i])
    lda.z i
    asl
    tay
    lda points,y
    sta.z print.p_x
    lda points+OFFSET_STRUCT_POINT_Y,y
    tay
    jsr print
    // for ( char i: 0..1)
    inc.z i
    lda #2
    cmp.z i
    bne __b1
    // }
    rts
}
// print(byte zp(3) p_x, byte register(Y) p_y)
print: {
    .label p_x = 3
    // SCREEN[idx++] = p.x
    lda.z p_x
    sta SCREEN,x
    // SCREEN[idx++] = p.x;
    inx
    // SCREEN[idx++] = p.y
    tya
    sta SCREEN,x
    // SCREEN[idx++] = p.y;
    inx
    // }
    rts
}
.segment Data
  points: .fill 2*2, 0
  __0: .byte 1, 2
  __1: .byte 3, 4
