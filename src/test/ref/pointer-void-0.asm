// Test simple void pointer (conversion without casting)
  // Commodore 64 PRG executable file
.file [name="pointer-void-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label wp = w
    .label vp = wp
    .label bp = vp
    .label w = 2
    // w = 1234
    lda #<$4d2
    sta.z w
    lda #>$4d2
    sta.z w+1
    // *SCREEN = *bp
    lda.z bp
    sta SCREEN
    // }
    rts
}
