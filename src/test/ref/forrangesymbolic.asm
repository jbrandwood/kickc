// Range-based for does not recognize symbolic constants.
// The following should work but gives a not-constant exception
  // Commodore 64 PRG executable file
.file [name="forrangesymbolic.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label BITMAP = $2000
    .label b = 2
    lda #<BITMAP+$1fff
    sta.z b
    lda #>BITMAP+$1fff
    sta.z b+1
  __b1:
    // *b = $5a
    lda #$5a
    ldy #0
    sta (b),y
    // for(byte* b : BITMAP+$1fff..BITMAP)
    lda.z b
    bne !+
    dec.z b+1
  !:
    dec.z b
    lda.z b+1
    cmp #>BITMAP-1
    bne __b1
    lda.z b
    cmp #<BITMAP-1
    bne __b1
    // }
    rts
}
