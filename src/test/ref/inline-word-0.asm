// Tests minimal inline word
  // Commodore 64 PRG executable file
.file [name="inline-word-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const w = 2*$100+1
    .label screen = $400
    // screen[0] = w
    lda #<w
    sta screen
    lda #>w
    sta screen+1
    // }
    rts
}
