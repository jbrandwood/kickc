// Tests calling through pointers to non-args no-return functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_POINTER = 2
main: {
    .label fn = 2
    .label fn_1 = 4
    // addrtable[0] = &myFunc
    lda #<myFunc
    sta addrtable
    lda #>myFunc
    sta addrtable+1
    // addrtable[1] = &myFunc2
    lda #<myFunc2
    sta addrtable+1*SIZEOF_POINTER
    lda #>myFunc2
    sta addrtable+1*SIZEOF_POINTER+1
    // fn = addrtable[0]
    lda addrtable
    sta.z fn
    lda addrtable+1
    sta.z fn+1
    // (*fn)()
    jsr bi_fn
    // fn = addrtable[1]
    lda addrtable+1*SIZEOF_POINTER
    sta.z fn_1
    lda addrtable+1*SIZEOF_POINTER+1
    sta.z fn_1+1
    // (*fn)()
    jsr bi_fn_1
    // }
    rts
  bi_fn:
    jmp (fn)
  bi_fn_1:
    jmp (fn_1)
}
myFunc2: {
    .label BG_COLOR = $d021
    // (*BG_COLOR)++;
    inc BG_COLOR
    // }
    rts
}
myFunc: {
    .label BORDER_COLOR = $d020
    // (*BORDER_COLOR)++;
    inc BORDER_COLOR
    // }
    rts
}
  addrtable: .fill 2*$100, 0
