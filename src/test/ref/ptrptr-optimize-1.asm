// Tests optimization of constant pointers to pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label pscreen = screen
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
    sta (main.pscreen),y
    inc main.pscreen
    bne !+
    inc main.pscreen+1
  !:
    rts
}
