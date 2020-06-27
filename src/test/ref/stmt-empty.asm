// Test an empty statement ';'
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  // Fill screen with '*'. Body is an empty statement.
  __b1:
    // for( char * screen = 0x0400; screen<0x400+1000; (*screen++)='*')
    lda.z screen+1
    cmp #>$400+$3e8
    bcc __b2
    bne !+
    lda.z screen
    cmp #<$400+$3e8
    bcc __b2
  !:
    // }
    rts
  __b2:
    // (*screen++)='*'
    lda #'*'
    ldy #0
    sta (screen),y
    // for( char * screen = 0x0400; screen<0x400+1000; (*screen++)='*')
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    jmp __b1
}
