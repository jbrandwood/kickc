// Tests optimization of constant pointers to pointers
  // Commodore 64 PRG executable file
.file [name="ptrptr-optimize-0.prg", type="prg", segments="Program"]
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
    // **pscreen = 'a'
    lda #'a'
    ldy.z pscreen
    sty.z $fe
    ldy.z pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // (*pscreen)++;
    inc.z pscreen
    bne !+
    inc.z pscreen+1
  !:
    // **pscreen = 'b'
    lda #'b'
    ldy.z pscreen
    sty.z $fe
    ldy.z pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // }
    rts
}
