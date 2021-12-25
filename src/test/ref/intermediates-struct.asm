// Test intermediate vars
  // Commodore 64 PRG executable file
.file [name="intermediates-struct.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_DATA_D = 1
  .const SIZEOF_STRUCT_DATA = 2
  .label SCREEN = $400
.segment Code
main: {
    .label x = 2
    .label y = 4
    // struct Data x = sum(1,2)
    ldx #2
    lda #1
    jsr sum
    // struct Data x = sum(1,2)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda sum.return-1,y
    sta x-1,y
    dey
    bne !-
    // SCREEN[idx++] = x.c
    lda.z x
    sta SCREEN
    // struct Data y = sum(3, 4)
    ldx #4
    lda #3
    jsr sum
    // struct Data y = sum(3, 4)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda sum.return-1,y
    sta y-1,y
    dey
    bne !-
    // SCREEN[idx++] = y.d
    lda.z y+OFFSET_STRUCT_DATA_D
    sta SCREEN+1
    // }
    rts
}
// __zp(6) struct Data sum(__register(A) char a, __register(X) char b)
sum: {
    .label return = 6
    .label d = 8
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // struct Data d = { a+b, b }
    sta.z d
    stx.z d+OFFSET_STRUCT_DATA_D
    // return d;
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda d-1,y
    sta return-1,y
    dey
    bne !-
    // }
    rts
}
