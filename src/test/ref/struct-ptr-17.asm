// Demonstrates problem with returning a struct into a dereferenced pointer to a struct
  // Commodore 64 PRG executable file
.file [name="struct-ptr-17.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_POINT_Y = 1
  .label SCREEN = $400
.segment Code
main: {
    .label __1_x = 2
    // get(0)
    lda #0
    jsr get
    // get(0)
    // *SCREEN = get(0)
    sta SCREEN
    lda #get.p_y
    sta SCREEN+OFFSET_STRUCT_POINT_Y
    ldy #1
  __b1:
    // get(i)
    tya
    jsr get
    // get(i)
    sta.z __1_x
    // SCREEN[i] = get(i)
    tya
    asl
    tax
    lda.z __1_x
    sta SCREEN,x
    lda #get.p_y
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
    .label p_y = 7
    rts
}
