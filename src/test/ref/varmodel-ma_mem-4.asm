// Test memory model
// Constant memory variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const a = 'a'
  .label screen = 2
main: {
    .const b = 'b'
    lda #0
    sta i
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  __b1:
    lda #a
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda #b
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda i
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
