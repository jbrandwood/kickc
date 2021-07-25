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
  // #pragma struct_model(classic)
  .label SCREEN = $400
.segment Code
main: {
    // sum(1,2)
    ldx #2
    lda #1
    jsr sum
    // sum(1,2)
    txa
    // struct Data x = sum(1,2)
    // SCREEN[idx++] = x.c
    sta SCREEN
    // sum(3, 4)
    ldx #4
    lda #3
    jsr sum
    // sum(3, 4)
    // struct Data y = sum(3, 4)
    // SCREEN[idx++] = y.d
    sta SCREEN+1
    // }
    rts
}
// sum(byte register(A) a, byte register(X) b)
sum: {
    .label d = 2
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // __ma struct Data d = { a+b, b }
    sta.z d
    stx d+OFFSET_STRUCT_DATA_D
    // return d;
    tax
    lda d+OFFSET_STRUCT_DATA_D
    // }
    rts
}
