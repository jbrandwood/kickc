// Tests a problem with tod018 not calculating types correctly
  // Commodore 64 PRG executable file
.file [name="tod018-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const d018val = >screen&$3fff
    .label D018 = $d018
    .label screen = $400
    // *D018 = d018val
    lda #d018val
    sta D018
    // }
    rts
}
