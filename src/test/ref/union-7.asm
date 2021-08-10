// Minimal union with C-Standard behavior - union parameter
  // Commodore 64 PRG executable file
.file [name="union-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNION_DATA = 2
  .label SCREEN = $400
.segment Code
main: {
    // print(data1)
    ldy #SIZEOF_UNION_DATA
  !:
    lda data1-1,y
    sta print.data-1,y
    dey
    bne !-
    ldx #0
    jsr print
    // print(data2)
    ldy #SIZEOF_UNION_DATA
  !:
    lda data2-1,y
    sta print.data-1,y
    dey
    bne !-
    jsr print
    // }
    rts
}
// void print(__zp(2) union Data data)
print: {
    .label data = 2
    // BYTE1(data.w)
    lda.z data+1
    // SCREEN[idx++] = BYTE1(data.w)
    sta SCREEN,x
    // SCREEN[idx++] = BYTE1(data.w);
    inx
    // SCREEN[idx++] = data.b
    lda.z data
    sta SCREEN,x
    // SCREEN[idx++] = data.b;
    inx
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,x
    // SCREEN[idx++] = ' ';
    inx
    // }
    rts
}
.segment Data
  data1: .byte $12
  .fill 1, 0
  data2: .byte $34
  .fill 1, 0
