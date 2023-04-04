  // File Comments
// More extensive union with C99 style designator initialization behaviour using const expressions.
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="union-12.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Global Constants & labels
  .label SCREEN = $400
.segment Code
  // main
main: {
    // SCREEN[0] = data.m.f
    // [0] *SCREEN = *((char *)(struct Move *)&data) -- _deref_pbuc1=_deref_pbuc2 
    lda data
    sta SCREEN
    // main::@return
    // }
    // [1] return 
    rts
}
  // File Data
.segment Data
  move: .byte 1, 2, 3
  data: .fill 1, 0
