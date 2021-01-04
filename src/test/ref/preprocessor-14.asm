// Test the preprocessor
// Test for existence of the __KICKC__ define
  // Commodore 64 PRG executable file
.file [name="preprocessor-14.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    // *SCREEN = 1
    lda #1
    sta SCREEN
    // }
    rts
}
