// Illustrates problem with passing an inline struct value as a parameter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // print('c', (struct format){ '-', '-' } )
    jsr print
    // }
    rts
}
print: {
    .const c = 'c'
    .const fmt_prefix = '-'
    .const fmt_postfix = '-'
    // SCREEN[idx++] = fmt.prefix
    lda #fmt_prefix
    sta SCREEN
    // SCREEN[idx++] = c
    lda #c
    sta SCREEN+1
    // SCREEN[idx++] = fmt.postfix
    lda #fmt_postfix
    sta SCREEN+2
    // }
    rts
}
