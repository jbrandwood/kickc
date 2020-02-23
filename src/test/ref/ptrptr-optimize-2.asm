// Tests (non-)optimization of constant pointers to pointers
// The two examples of &screen is not detected as identical leading to ASM that could be optimized more
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    // screen = 0x400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    // sub('a',&screen)
    lda #'a'
    jsr sub
    // sub('b',&screen)
    lda #'b'
    jsr sub
    // }
    rts
}
// sub(byte register(A) ch)
sub: {
    // *(*dst)++ = ch
    ldy.z main.screen
    sty.z $fe
    ldy.z main.screen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(*dst)++ = ch;
    inc.z main.screen
    bne !+
    inc.z main.screen+1
  !:
    // }
    rts
}
