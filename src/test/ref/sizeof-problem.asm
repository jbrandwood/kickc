  // Commodore 64 PRG executable file
.file [name="sizeof-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
.segment Code
main: {
    .const i = $130*SIZEOF_BYTE
    .const j = 3*SIZEOF_BYTE
    // ARR1[i-1] = 0
    lda #0
    sta ARR1+i-1
    // ARR2[j-1] = 0
    sta ARR2+j-1
    // }
    rts
}
.segment Data
  ARR1: .fill $130, 0
  ARR2: .byte 1, 2, 3
