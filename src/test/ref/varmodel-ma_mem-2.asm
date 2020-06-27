// Test memory model multiple-assignment/main memory for all non-pointer variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // A local pointer 
    .label screen = 2
    // screen = 0x0400
    // A local pointer 
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    // for( char i: 0..5 )
    lda #0
    sta i
  // A local counter
  __b1:
    // *(screen++) = 'a'
    lda #'a'
    ldy #0
    sta (screen),y
    // *(screen++) = 'a';
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // for( char i: 0..5 )
    inc i
    lda #6
    cmp i
    bne __b1
    // }
    rts
    i: .byte 0
}
