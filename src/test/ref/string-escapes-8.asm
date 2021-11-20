// Support for '\0' literal character
  // Commodore 64 PRG executable file
.file [name="string-escapes-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[0] = '\0'
    lda #'@'
    sta SCREEN
    // }
    rts
}
