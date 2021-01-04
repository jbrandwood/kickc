// Tests the sizeof() operator on values/expressions
  // Commodore 64 PRG executable file
.file [name="sizeof-expr.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_BYTE = 1
  .const SIZEOF_NUMBER = $ff
  .const SIZEOF_WORD = 2
  .const SIZEOF_POINTER = 2
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[idx++] = '0'+sizeof(0)
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN
    // SCREEN[idx++] = '0'+sizeof(idx)
    lda #'0'+SIZEOF_BYTE
    sta SCREEN+1
    // SCREEN[idx++] = '0'+sizeof(b)
    sta SCREEN+2
    // SCREEN[idx++] = '0'+sizeof(b*2)
    lda #'0'+SIZEOF_NUMBER
    sta SCREEN+3
    // SCREEN[idx++] = '0'+sizeof($43ff)
    sta SCREEN+5
    // SCREEN[idx++] = '0'+sizeof(w)
    lda #'0'+SIZEOF_WORD
    sta SCREEN+6
    // SCREEN[idx++] = '0'+sizeof(bp)
    lda #'0'+SIZEOF_POINTER
    sta SCREEN+8
    // SCREEN[idx++] = '0'+sizeof(wp)
    sta SCREEN+9
    // }
    rts
}
