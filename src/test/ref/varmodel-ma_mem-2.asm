// Test memory model multiple-assignment/main memory for all non-pointer variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    // A local pointer 
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #0
    sta i
  // A local counter
  __b1:
    lda #'a'
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc i
    lda #6
    cmp i
    bne __b1
    rts
    i: .byte 0
}
