.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
//  Tests a pointer to a boolean
main: {
    lda #1
    sta $400
    lda #0
    sta $400+1
    lda #1
    sta $400+2
    cmp #0
    bne b2
  breturn:
    rts
  b2:
    lda #1
    sta $400+2+1
    jmp breturn
}
