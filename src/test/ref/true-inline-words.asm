.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    //  constant byte array
    .const b = 4
    //  Test the result
    .label pos = $501
    .label bgcol = $d021
    .const w = b*$100
    .const w2 = 1*$100+1+w+0
    //  implicit cast to (byte*)
    lda bs+1
    sta w2
    lda pos
    cmp #'m'
    beq b1
    lda #2
    sta bgcol
  breturn:
    rts
  b1:
    lda #5
    sta bgcol
    jmp breturn
    bs: .byte 'c', 'm'
}
