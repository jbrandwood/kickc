// Illustrates how inline assembler can reference data from the outside program
  // Commodore 64 PRG executable file
.file [name="inline-asm-refout.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *(SCREEN+40) = table[0]
    lda table
    sta SCREEN+$28
    // asm
    ldx #0
  !:
    lda table,x
    sta SCREEN+1,x
    inx
    cpx #4
    bne !-
    // }
    rts
}
.segment Data
  table: .text "cml!"
