// Tests the sizeof() operator on arrays
  // Commodore 64 PRG executable file
.file [name="sizeof-arrays.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
  .const SIZEOF_WORD = 2
  .label SCREEN = $400
.segment Code
main: {
    .const sz = 7
    // SCREEN[idx++] = '0'+(char)(sizeof(ba)/sizeof(byte))
    lda #'0'+3*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN
    // SCREEN[idx++] = '0'+(char)(sizeof(wa)/sizeof(word))
    lda #'0'+3*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+1
    // SCREEN[idx++] = '0'+(char)(sizeof(bb)/sizeof(byte))
    lda #'0'+(sz+2)*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+2
    // SCREEN[idx++] = '0'+(char)(sizeof(wb)/sizeof(word))
    lda #'0'+4*SIZEOF_WORD/SIZEOF_WORD
    sta SCREEN+3
    // SCREEN[idx++] = '0'+(char)(sizeof(sa)/sizeof(byte))
    lda #'0'+8*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+4
    // SCREEN[idx++] = '0'+(char)(sizeof(sb)/sizeof(byte))
    lda #'0'+4*SIZEOF_BYTE/SIZEOF_BYTE
    sta SCREEN+5
    // }
    rts
}
