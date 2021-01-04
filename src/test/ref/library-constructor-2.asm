// Demonstrates Library Constructor Functionality
// Constructors are removed if not needed
  // Commodore 64 PRG executable file
.file [name="library-constructor-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[2] = '*'
    lda #'*'
    sta SCREEN+2
    // }
    rts
}
