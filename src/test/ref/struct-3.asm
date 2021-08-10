// Minimal struct - passing struct value parameter
  // Commodore 64 PRG executable file
.file [name="struct-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label p1_y = 4
    // print(p1)
    ldx #0
    lda #1
    jsr print
    // print(p1)
    lda #2
    jsr print
    // }
    rts
}
// void print(__register(A) char p_x, char p_y)
print: {
    // SCREEN[idx++] = p.x
    sta SCREEN,x
    // SCREEN[idx++] = p.x;
    inx
    // SCREEN[idx++] = p.y
    lda #main.p1_y
    sta SCREEN,x
    // SCREEN[idx++] = p.y;
    inx
    // }
    rts
}
