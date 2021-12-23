// Test #pragma without parenthesis
  // Commodore VIC 20 unexpanded executable PRG file
.file [name="pragma-noparenthesis.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$1001]
.segmentdef Code [start=$100d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
.segment Code
__start: {
    jsr init
    jsr main
    rts
}
init: {
    // SCREEN[0] = 'a'
    lda #'a'
    sta SCREEN
    // }
    rts
}
main: {
    // SCREEN[1] = 'b'
    lda #'b'
    sta SCREEN+1
    // }
    rts
}
