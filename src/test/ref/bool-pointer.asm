// Tests a pointer to a boolean
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // bscreen[0] = true
    lda #1
    sta $400
    // bscreen[1] = false
    lda #0
    sta $400+1
    // *bscreen = true
    lda #1
    sta $400+2
    // if(*bscreen)
    cmp #0
    bne __b1
    rts
  __b1:
    // *(++bscreen)= true
    lda #1
    sta $400+3
    // }
    rts
}
