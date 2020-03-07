// Test compound assignment operators
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen1 = $400
  .label cols = $d800
  .const GREEN = 5
  .const RED = 2
  .label screen2 = screen1+$28
main: {
    // test(i++, a)
  //3
    ldx #0
    lda #3
    sta.z test.a
    jsr test
    // test(i++, a)
  //4
    ldx #1
    lda #3+1
    sta.z test.a
    jsr test
    // test(i++, a)
  //3
    ldx #2
    lda #3+1-1
    sta.z test.a
    jsr test
    // test(i++, a)
  //18
    ldx #3
    lda #(3+1-1)*6
    sta.z test.a
    jsr test
    // test(i++, a)
  //9
    ldx #4
    lda #(3+1-1)*6/2
    sta.z test.a
    jsr test
    // test(i++, a)
  //1
    ldx #5
    lda #(3+1-1)*6/2&2-1
    sta.z test.a
    jsr test
    // test(i++, a)
  //4
    ldx #6
    lda #((3+1-1)*6/2&2-1)<<2
    sta.z test.a
    jsr test
    // test(i++, a)
  //2
    ldx #7
    lda #((3+1-1)*6/2&2-1)<<2>>1
    sta.z test.a
    jsr test
    // test(i++, a)
  //4
    ldx #8
    lda #((3+1-1)*6/2&2-1)<<2>>1^6
    sta.z test.a
    jsr test
    // test(i++, a)
  //5
    ldx #9
    lda #((3+1-1)*6/2&2-1)<<2>>1^6|1
    sta.z test.a
    jsr test
    // test(i++, a)
  //1
    ldx #$a
    lda #(((3+1-1)*6/2&2-1)<<2>>1^6|1)&1
    sta.z test.a
    jsr test
    // }
    rts
}
// test(byte register(X) i, byte zp(2) a)
test: {
    .label a = 2
    // screen1[i] = a
    lda.z a
    sta screen1,x
    // screen2[i] = ref[i]
    lda ref,x
    sta screen2,x
    // if(ref[i]==a)
    lda ref,x
    cmp.z a
    beq __b1
    // cols[i] = RED
    lda #RED
    sta cols,x
    // }
    rts
  __b1:
    // cols[i] = GREEN
    lda #GREEN
    sta cols,x
    rts
}
  ref: .byte 3, 4, 3, $12, 9, 1, 4, 2, 4, 5, 1, 0
