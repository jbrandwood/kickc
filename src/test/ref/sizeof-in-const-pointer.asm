// Support for sizeof() in const pointer definition
  // Commodore 64 PRG executable file
.file [name="sizeof-in-const-pointer.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
  // Commodore 64 processor port
  .label SCREEN = $400+SIZEOF_BYTE*$64
.segment Code
main: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
