// Illustrates how inline assembler use internal labels and external references
  // Commodore 64 PRG executable file
.file [name="inline-asm-label.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // asm
    ldx #0
  nxt:
    lda table,x
    sta SCREEN+1,x
    inx
    cpx #4
    bne nxt
    // }
    rts
}
.segment Data
  table: .text "cml!"
