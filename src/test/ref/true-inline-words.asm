.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // constant byte array
    .const b = 4
    // Test the result
    .label pos = $501
    .label bgcol = $d021
    .const w = b*$100
    .const w2 = 1*$100+1+w
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
    // *bgcol = 2
    lda #2
    sta bgcol
    // }
    rts
  __b1:
    // *bgcol = 5
    lda #5
    sta bgcol
    rts
    bs: .byte 'c', 'm'
}
