// Demonstrates problem with passing struct pointer deref as parameter to call
  // Commodore 64 PRG executable file
.file [name="struct-ptr-19.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_POINT = 2
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
  .label idx = 2
.segment Code
main: {
    .label ptr = point
    .label point = 3
    // struct Point point = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta point-1,y
    dey
    bne !-
    // print(point)
    ldy.z point
    ldx.z point+OFFSET_STRUCT_POINT_Y
    lda #0
    sta.z idx
    jsr print
    // print(*ptr)
    ldy.z ptr
    ldx.z ptr+OFFSET_STRUCT_POINT_Y
    jsr print
    // }
    rts
}
// void print(__register(Y) char p_x, __register(X) char p_y)
print: {
    // SCREEN[idx++] = p.x
    tya
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = p.x;
    iny
    // SCREEN[idx++] = p.y
    txa
    sta SCREEN,y
    // SCREEN[idx++] = p.y;
    iny
    sty.z idx
    // }
    rts
}
.segment Data
  __0: .byte 1, 2
