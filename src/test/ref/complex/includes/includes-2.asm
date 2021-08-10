// Includes a local file with the same name as a system library
  // Commodore 64 PRG executable file
.file [name="includes-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // strlen(STR)
    jsr strlen
    // SCREEN [0] = (char) strlen(STR)
    lda #strlen.return
    sta SCREEN
    // }
    rts
}
// A local stdlib include file
// unsigned int strlen(char *str)
strlen: {
    .label return = 'x'
    rts
}
