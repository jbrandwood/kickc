// Tests creating pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
fn2: {
    .label BG_COLOR = $d021
    // (*BG_COLOR)++;
    inc BG_COLOR
    // }
    rts
}
fn1: {
    .label BORDER_COLOR = $d020
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // }
    rts
}
main: {
    .label SCREEN = $400
    // SCREEN[0] = BYTE0((word)f)
    lda #<fn1
    sta SCREEN
    // SCREEN[1] = BYTE1((word)f)
    lda #>fn1
    sta SCREEN+1
    // SCREEN[2] = BYTE0((word)f)
    lda #<fn2
    sta SCREEN+2
    // SCREEN[3] = BYTE1((word)f)
    lda #>fn2
    sta SCREEN+3
    // }
    rts
}
