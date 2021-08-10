// Test combining unwind structs with classic structs
// Function calls parameter passing
  // Commodore 64 PRG executable file
.file [name="struct-unwinding-2.prg", type="prg", segments="Program"]
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
    .const p2_x = 3
    .const p2_y = 4
    .label p1 = 3
    // __ma struct Point p1 = { 1, 2 }
    ldy #SIZEOF_STRUCT_POINT
  !:
    lda __0-1,y
    sta p1-1,y
    dey
    bne !-
    // print1(p1, 0)
    ldy.z p1
    ldx p1+OFFSET_STRUCT_POINT_Y
  // Pass classic struct to function taking unwound struct
    lda #0
    jsr print1
    // print2(p1, 2)
    ldy.z p1
    ldx p1+OFFSET_STRUCT_POINT_Y
  // Pass classic struct to function taking classic struct
    lda #2
    jsr print2
    // print1(p2, 4)
  // Pass unwound struct to function taking unwound struct
    ldx #p2_y
    ldy #p2_x
    lda #4
    jsr print1
    // print2(p2, 6)
  // Pass unwound struct to function taking classic struct
    ldx #p2_y
    ldy #p2_x
    lda #6
    jsr print2
    // }
    rts
}
// Function taking unwound struct as parameter
// void print1(__register(Y) char p_x, __register(X) char p_y, __register(A) char idx)
print1: {
    .label __0 = 2
    // SCREEN[idx] = p
    asl
    sta.z __0
    tya
    ldy.z __0
    sta SCREEN,y
    txa
    sta SCREEN+OFFSET_STRUCT_POINT_Y,y
    // }
    rts
}
// Function taking classic struct as parameter
// void print2(__register(Y) char p_x, __register(X) char p_y, __register(A) char idx)
print2: {
    .label __0 = 2
    // SCREEN[idx] = p
    asl
    sta.z __0
    tya
    ldy.z __0
    sta SCREEN,y
    txa
    sta SCREEN+OFFSET_STRUCT_POINT_Y,y
    // }
    rts
}
.segment Data
  __0: .byte 1, 2
