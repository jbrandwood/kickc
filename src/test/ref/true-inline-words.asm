.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const b = 4
    .label pos = $501
    .label bgcol = $d021
    .const w = b*$100
    .const w2 = 1*$100+1+w+0
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
