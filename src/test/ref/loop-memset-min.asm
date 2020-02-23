// Minimal classic for() loop - coded using while() to test optimization of loop heads
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // memset(SCREEN, 'c', 1000)
    jsr memset
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .label str = SCREEN
    .const c = 'c'
    .const num = $3e8
    .label end = str+num
    .label dst = 2
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // while(dst!=end)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // dst++;
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
