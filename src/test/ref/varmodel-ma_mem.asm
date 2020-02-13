// Test memory model multiple-assignment/main memory for all variables (here  local variables)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // A local pointer 
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #0
    sta i
  // A local counter
  __b1:
    lda #'a'
    ldy screen
    sty.z $fe
    ldy screen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc i
    lda #6
    cmp i
    bne __b1
    rts
    screen: .word 0
    i: .byte 0
}
