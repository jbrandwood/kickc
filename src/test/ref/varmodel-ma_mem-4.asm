// Test memory model
// Constant memory variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const a = 'a'
  .label screen = 2
main: {
    .const b = 'b'
    // for( char i: 0..5 )
    lda #0
    sta i
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    // *(screen++) = a
    lda #a
    ldy #0
    sta (screen),y
    // *(screen++) = a;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *(screen++) = b
    lda #b
    ldy #0
    sta (screen),y
    // *(screen++) = b;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    // *(screen++) = i
    lda i
    ldy #0
    sta (screen),y
    // *(screen++) = i;
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
