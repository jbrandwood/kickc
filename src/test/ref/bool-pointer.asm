// Tests a pointer to a boolean
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #1
    sta $400
    lda #0
    sta $400+1
    lda #1
    sta $400+2
    cmp #0
    bne __b1
    rts
  __b1:
    lda #1
    sta $400+3
    rts
}
