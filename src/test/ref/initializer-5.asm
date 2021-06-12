// Demonstrates initializing an array of structs - with trailing commas
  // Commodore 64 PRG executable file
.file [name="initializer-5.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
.segment Code
main: {
    .label SCREEN = $400
    .label __4 = 3
    .label idx = 2
    lda #0
    sta.z idx
    tax
  __b1:
    // SCREEN[idx++] = points[i].x
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    sta.z __4
    tay
    lda points,y
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = points[i].x;
    inc.z idx
    // BYTE0(points[i].y)
    ldy.z __4
    lda points+OFFSET_STRUCT_POINT_Y,y
    // SCREEN[idx++] = BYTE0(points[i].y)
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = BYTE0(points[i].y);
    inc.z idx
    // BYTE1(points[i].y)
    ldy.z __4
    lda points+OFFSET_STRUCT_POINT_Y+1,y
    // SCREEN[idx++] = BYTE1(points[i].y)
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = BYTE1(points[i].y);
    inc.z idx
    // for( char i: 0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
.segment Data
  points: .byte 1
  .word 2
  .byte 3
  .word 4
  .byte 5
  .word 6
