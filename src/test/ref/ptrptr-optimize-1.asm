// Tests optimization of constant pointers to pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label pscreen = screen
    .label screen = 2
    // screen = 0x400
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    // sub('a',pscreen)
    lda #'a'
    jsr sub
    // sub('b',pscreen)
    lda #'b'
    jsr sub
    // }
    rts
}
// sub(byte register(A) ch)
sub: {
    // *(*dst)++ = ch
    ldy.z main.pscreen
    sty.z $fe
    ldy.z main.pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    // *(*dst)++ = ch;
    inc.z main.pscreen
    bne !+
    inc.z main.pscreen+1
  !:
    // }
    rts
}
