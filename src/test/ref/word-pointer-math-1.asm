// Tests word pointer math - subtracting two word pointers
  // Commodore 64 PRG executable file
.file [name="word-pointer-math-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_WORD = 2
.segment Code
main: {
    .const wd = (w2-w1)/SIZEOF_WORD
    .label SCREEN = $400
    .label w1 = $1000
    .label w2 = $1140
    // *SCREEN = wd
    lda #<wd
    sta SCREEN
    lda #>wd
    sta SCREEN+1
    // }
    rts
}
