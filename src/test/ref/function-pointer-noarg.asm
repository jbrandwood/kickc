// Tests creating pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    // SCREEN[0] = <(word)f
    lda #<fn1
    sta SCREEN
    // SCREEN[1] = >(word)f
    lda #>fn1
    sta SCREEN+1
    // SCREEN[2] = <(word)f
    lda #<fn2
    sta SCREEN+2
    // SCREEN[3] = >(word)f
    lda #>fn2
    sta SCREEN+3
    // }
    rts
}
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
