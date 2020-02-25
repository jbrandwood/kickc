// Demonstrates error with nested ternary operator
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // (b == 0) ? 'a' : ((b == 1) ? 'b' : 'c')
    cpx #0
    beq b1
    // (b == 1) ? 'b' : 'c'
    cpx #1
    beq __b4
    lda #'c'
    jmp __b3
  __b4:
    lda #'b'
    jmp __b3
  b1:
    lda #'a'
  __b3:
    // *SCREEN = (b == 0) ? 'a' : ((b == 1) ? 'b' : 'c')
    sta SCREEN
    // for ( byte b: 0..2 )
    inx
    cpx #3
    bne __b1
    // }
    rts
}
