  // Commodore 64 PRG executable file
.file [name="missing-instruction.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label test = 2
    // volatile unsigned char test
    lda #0
    sta.z test
    // asm
    sty.z test,x
    // }
    rts
}
