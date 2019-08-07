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
    ldy #0
    sta (pscreen),y
    inc pscreen
    bne !+
    inc pscreen+1
  !:
    lda #'b'
    ldy #0
    sta (pscreen),y
    rts
}
