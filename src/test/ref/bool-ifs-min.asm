// A test of boolean conditions using && || and !
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( (i<10) && ((i&1)==0) )
    cpx #$a
    bcs __b2
    cmp #0
    bne __b2
    // screen[i] = '*'
    lda #'*'
    sta screen,x
  __b2:
    // for( char i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
}
