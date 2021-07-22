// Minimal union with C-Standard behavior
  // Commodore 64 PRG executable file
.file [name="union-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_UNION_DATA = 2
  .label SCREEN = $400
.segment Code
main: {
    // data.w = 1234
    lda #<$4d2
    sta data
    lda #>$4d2
    sta data+1
    // SCREEN[0] = data.b
    lda data
    sta SCREEN
    // }
    rts
}
.segment Data
  data: .fill SIZEOF_UNION_DATA, 0
