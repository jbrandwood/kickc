// Tests calling through pointers to non-args no-return functions
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-12.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_POINTER = 2
.segment Code
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
    // void(*fn)() = addrtable[0]
    lda addrtable
    sta.z fn
    lda addrtable+1
    sta.z fn+1
    // (*fn)()
    jsr icall1
    // fn = addrtable[1]
    lda addrtable+1*SIZEOF_POINTER
    sta.z fn_1
    lda addrtable+1*SIZEOF_POINTER+1
    sta.z fn_1+1
    // (*fn)()
    jsr icall2
    // }
    rts
  icall1:
    jmp (fn)
  icall2:
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
.segment Data
  addrtable: .fill 2*$100, 0
