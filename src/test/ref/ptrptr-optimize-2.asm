// Tests (non-)optimization of constant pointers to pointers
// The two examples of &screen is not detected as identical leading to ASM that could be optimized more
  // Commodore 64 PRG executable file
.file [name="ptrptr-optimize-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = 2
    // byte* screen = (char*)0x400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    // sub('a',&screen)
    lda #'a'
    jsr sub
    // sub('b',&screen)
    lda #'b'
    jsr sub
    // }
    rts
}
// sub(byte register(A) ch)
sub: {
    // *(*dst)++ = ch
    ldy.z main.screen
    sty.z $fe
    ldy.z main.screen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(*dst)++ = ch;
    inc.z main.screen
    bne !+
    inc.z main.screen+1
  !:
    // }
    rts
}
