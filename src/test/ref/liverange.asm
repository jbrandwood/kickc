  // Commodore 64 PRG executable file
.file [name="liverange.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    .label a = 2
    // inci()
    ldy #0
    jsr inci
    // inci()
    // a=a+inci()
    clc
    adc #4
    sta.z a
    // inci()
    jsr inci
    // inci()
    // a=a+inci()
    clc
    adc.z a
    // *SCREEN = i
    sty SCREEN
    // *(SCREEN+1) = a
    sta SCREEN+1
    // }
    rts
}
inci: {
    // i+7
    tya
    clc
    adc #7
    tay
    // return i;
    tya
    // }
    rts
}
