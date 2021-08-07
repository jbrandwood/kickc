// Tests the sizeof operator without parenthesis
  // Commodore 64 PRG executable file
.file [name="sizeof-noparen.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
  .const SIZEOF_SIGNED_WORD = 2
  .const SIZEOF_NUMBER = -1
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = '0'+sizeof 0
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof b
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+1
    // SCREEN[idx++] = '0'+sizeof w
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+2
    // SCREEN[idx++] = '0'+sizeof (char)
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof (int)
    lda #'0'+SIZEOF_SIGNED_WORD
    sta SCREEN+4
    // }
    rts
}
