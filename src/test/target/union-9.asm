  // File Comments
// Minimal union with C-Standard behavior
  // Upstart
.cpu _65c02
  // Commodore 64 PRG executable file
.file [name="union-9.prg", type="prg", segments="Program"]
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
    // SCREEN[0] = data.b
    // [0] *SCREEN = *((char *)&data) -- _deref_pbuc1=_deref_pbuc2 
    lda data
    sta SCREEN
    // main::@return
    // }
    // [1] return 
    rts
}
  // File Data
.segment Data
  data: .word $4d2
