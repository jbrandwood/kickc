.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // constant byte array
    // constant byte array
    .const b = 4
    // constant byte
    .const w = b*$100
    // constant inline word
    .const w2 = 1*$100+1+w
    // Test the result
    // Test the result
    .label pos = $501
    .label BG_COLOR = $d021
    // constant inline words inside expression
    // constant inline words inside expression
    .label sc = w2
    // *sc = bs[1]
    // implicit cast to (byte*)
    lda bs+1
    sta sc
    // if(*pos=='m')
    lda #'m'
    cmp pos
    beq __b1
    // *BG_COLOR = 2
    lda #2
    sta BG_COLOR
    // }
    rts
  __b1:
    // *BG_COLOR = 5
    lda #5
    sta BG_COLOR
    rts
    bs: .byte 'c', 'm'
}
