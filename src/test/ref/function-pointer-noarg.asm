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
    .label BGCOL = $d021
    // (*BGCOL)++;
    inc BGCOL
    // }
    rts
}
fn1: {
    .label BORDERCOL = $d020
    // (*BORDERCOL)++;
    inc BORDERCOL
    // }
    rts
}
