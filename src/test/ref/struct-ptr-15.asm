// Minimal struct -  using pointers to nested structs
  // Commodore 64 PRG executable file
.file [name="struct-ptr-15.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_CIRCLE = 3
  .const OFFSET_STRUCT_CIRCLE_CENTER = 1
  .const OFFSET_STRUCT_POINT_Y = 1
.segment Code
main: {
    .label SCREEN = $400
    .label __28 = 6
    .label x = 5
    .label ptr = 2
    .label i = 4
    // circles[0].center.x = 2
    lda #2
    sta circles+OFFSET_STRUCT_CIRCLE_CENTER
    // circles[0].center.y = 3
    lda #3
    sta circles+OFFSET_STRUCT_POINT_Y+OFFSET_STRUCT_CIRCLE_CENTER
    // circles[0].radius = 5
    lda #5
    sta circles
    // circles[1].center.x = 8
    lda #8
    sta circles+1*SIZEOF_STRUCT_CIRCLE+OFFSET_STRUCT_CIRCLE_CENTER
    // circles[1].center.y = 9
    lda #9
    sta circles+1*SIZEOF_STRUCT_CIRCLE+OFFSET_STRUCT_POINT_Y+OFFSET_STRUCT_CIRCLE_CENTER
    // circles[1].radius = 15
    lda #$f
    sta circles+1*SIZEOF_STRUCT_CIRCLE
    lda #0
    sta.z i
    tax
    lda #<circles
    sta.z ptr
    lda #>circles
    sta.z ptr+1
  __b1:
    // byte x = ptr->center.x
    ldy #OFFSET_STRUCT_CIRCLE_CENTER
    lda (ptr),y
    sta.z x
    // byte y = ptr->center.y
    tya
    clc
    adc.z ptr
    sta.z __28
    lda #0
    adc.z ptr+1
    sta.z __28+1
    ldy #OFFSET_STRUCT_POINT_Y
    lda (__28),y
    tay
    // SCREEN[idx++] = x
    lda.z x
    sta SCREEN,x
    // SCREEN[idx++] = x;
    inx
    // SCREEN[idx++] = y
    tya
    sta SCREEN,x
    // SCREEN[idx++] = y;
    inx
    // ptr++;
    lda #SIZEOF_STRUCT_CIRCLE
    clc
    adc.z ptr
    sta.z ptr
    bcc !+
    inc.z ptr+1
  !:
    // for(byte i:0..1)
    inc.z i
    lda #2
    cmp.z i
    bne __b1
    // }
    rts
}
.segment Data
  circles: .fill 3*2, 0
