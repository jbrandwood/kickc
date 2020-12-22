  // Commodore 64 PRG executable file
.file [name="typedef-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const b = 'a'
    .label SCREEN = $400
    // *SCREEN = b
    lda #b
    sta SCREEN
    // }
    rts
}
