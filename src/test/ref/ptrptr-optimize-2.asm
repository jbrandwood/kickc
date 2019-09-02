// Tests (non-)optimization of constant pointers to pointers
// The two examples of &screen is not detected as identical leading to ASM that could be optimized more
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #'a'
    jsr sub
    lda #'b'
    jsr sub
    rts
}
// sub(byte register(A) ch)
sub: {
    ldy #0
    sta (main.screen),y
    inc.z main.screen
    bne !+
    inc.z main.screen+1
  !:
    rts
}
