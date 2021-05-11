// Tests optimization of constant pointers to pointers
  // Commodore 64 PRG executable file
.file [name="ptrptr-optimize-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label pscreen = screen
    .label screen = 2
    // byte* screen = (char*)0x400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    // sub('a',pscreen)
    lda #'a'
    jsr sub
    // sub('b',pscreen)
    lda #'b'
    jsr sub
    // }
    rts
}
// sub(byte register(A) ch)
sub: {
    // *(*dst)++ = ch
    ldy.z main.pscreen
    sty.z $fe
    ldy.z main.pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(*dst)++ = ch;
    inc.z main.pscreen
    bne !+
    inc.z main.pscreen+1
  !:
    // }
    rts
}
