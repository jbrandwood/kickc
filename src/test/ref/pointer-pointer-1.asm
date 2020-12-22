// Tests a simple pointer to a pointer
  // Commodore 64 PRG executable file
.file [name="pointer-pointer-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label ppb = pb
    .label b = 2
    .label pb = 3
    // b = 'a'
    lda #'a'
    sta.z b
    // pb = &b
    lda #<b
    sta.z pb
    lda #>b
    sta.z pb+1
    // *SCREEN = **ppb
    ldy.z ppb
    sty.z $fe
    ldy.z ppb+1
    sty.z $ff
    ldy #0
    lda ($fe),y
    sta SCREEN
    // }
    rts
}
