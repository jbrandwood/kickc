.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen1 = $400
  .label cols = $d800
  .const GREEN = 5
  .const RED = 2
  .label screen2 = screen1+$28
main: {
    ldx #0
    lda #3
    sta test.a
    jsr test
    ldx #1
    lda #3+1
    sta test.a
    jsr test
    ldx #2
    lda #3+1-1
    sta test.a
    jsr test
    ldx #3
    lda #(3+1-1)*6
    sta test.a
    jsr test
    ldx #4
    lda #(3+1-1)*6/2
    sta test.a
    jsr test
    ldx #5
    lda #mod((3+1-1)*6/2,2)
    sta test.a
    jsr test
    ldx #6
    lda #mod((3+1-1)*6/2,2)<<2
    sta test.a
    jsr test
    ldx #7
    lda #mod((3+1-1)*6/2,2)<<2>>1
    sta test.a
    jsr test
    ldx #8
    lda #mod((3+1-1)*6/2,2)<<2>>1^6
    sta test.a
    jsr test
    ldx #9
    lda #mod((3+1-1)*6/2,2)<<2>>1^6|1
    sta test.a
    jsr test
    ldx #$a
    lda #(mod((3+1-1)*6/2,2)<<2>>1^6|1)&1
    sta test.a
    jsr test
    rts
}
test: {
    .label a = 2
    lda a
    sta screen1,x
    lda ref,x
    sta screen2,x
    lda ref,x
    cmp a
    beq b1
    lda #RED
    sta cols,x
  breturn:
    rts
  b1:
    lda #GREEN
    sta cols,x
    jmp breturn
}
  //  Test compound assignment operators
  ref: .byte 3, 4, 3, $12, 9, 1, 4, 2, 4, 5, 1, 0
