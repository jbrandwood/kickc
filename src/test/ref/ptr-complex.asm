// Test some complex pointers
  // Commodore 64 PRG executable file
.file [name="ptr-complex.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    // RValue pointer expression (constant)
    .label screen = $400
    // Increment on a const named pointer
    .label BG_COLOR = $d020
    .label sc2 = screen+$51
    ldx #0
  // RValue pointer expression (variable)
  __b1:
    // screen[i] = *(screen+40+i)
    lda screen+$28,x
    sta screen,x
    // for(byte i : 0..10)
    inx
    cpx #$b
    bne __b1
    // *sc2 = *(screen+121)
    lda screen+$79
    sta sc2
    // *(screen+82) = *(screen+122)
    // LValue pointer expression (constant - directly)
    lda screen+$7a
    sta screen+$52
    ldx #0
  // LValue pointer expression (variable - directly)
  __b3:
    // *(screen+160+j) = *(screen+200+j)
    lda screen+$c8,x
    sta screen+$a0,x
    // for(byte j : 0..10)
    inx
    cpx #$b
    bne __b3
    // ++*(byte*)$d020;
    inc $d020
    // --*(byte*)($d000+$21);
    dec $d000+$21
    // ++*BG_COLOR;
    inc BG_COLOR
    // }
    rts
}
