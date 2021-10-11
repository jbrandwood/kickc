// Illustrates how inline kickassembler can reference data from the outside program
  // Commodore 64 PRG executable file
.file [name="inline-kasm-refout.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // kickasm
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
  .byte 0
