  // Commodore 64 PRG executable file
.file [name="minus-precedence-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const matrixSize = 8
  .const matrixSizeMask = $ff-(matrixSize-1)
.segment Code
main: {
    // *((unsigned char *)0x400) = matrixSizeMask
    lda #matrixSizeMask
    sta $400
    // }
    rts
}
