// Test intermediate vars
  // Commodore 64 PRG executable file
.file [name="intermediates-struct.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_DATA = 2
  .const OFFSET_STRUCT_DATA_D = 1
  .label SCREEN = $400
.segment Code
main: {
    .label x = 2
    .label __0 = 4
    .label y = 6
    .label __1 = 8
    // sum(1,2)
    ldx #2
    lda #1
    jsr sum
    // sum(1,2)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda sum.return-1,y
    sta __0-1,y
    dey
    bne !-
    // struct Data x = sum(1,2)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda __0-1,y
    sta x-1,y
    dey
    bne !-
    // SCREEN[idx++] = x.c
    lda.z x
    sta SCREEN
    // sum(3, 4)
    ldx #4
    lda #3
    jsr sum
    // sum(3, 4)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda sum.return-1,y
    sta __1-1,y
    dey
    bne !-
    // struct Data y = sum(3, 4)
    ldy #SIZEOF_STRUCT_DATA
  !:
    lda __1-1,y
    sta y-1,y
    dey
    bne !-
    // SCREEN[idx++] = y.d
    lda y+OFFSET_STRUCT_DATA_D
    sta SCREEN+1
    // }
    rts
}
// sum(byte register(A) a, byte register(X) b)
sum: {
    .label return = $a
    .label d = $c
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // __ma struct Data d = { a+b, b }
    sta.z d
    stx d+OFFSET_STRUCT_DATA_D
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
