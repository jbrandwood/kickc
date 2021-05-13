  // Commodore 64 PRG executable file
.file [name="npe-problem-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = *bram_base++
    lda bram
    sta SCREEN
    // SCREEN[1] = *bram_base++
    lda bram+1
    sta SCREEN+1
    // }
    rts
}
.segment Data
  bram: .fill $64, 0
