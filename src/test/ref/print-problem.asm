  // Commodore 64 PRG executable file
.file [name="print-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // ln()
    lda #$40
    jsr ln
    // ln()
    jsr ln
    // ln()
    jsr ln
    // *SCREEN = ch
    sta SCREEN
    // *(SCREEN+40) = line
    sta SCREEN+$28
    // }
    rts
}
ln: {
    // line + $2
    clc
    adc #2
    // }
    rts
}
