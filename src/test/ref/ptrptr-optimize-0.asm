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
    ldy.z pscreen
    sty.z $fe
    ldy.z pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    inc.z pscreen
    bne !+
    inc.z pscreen+1
  !:
    lda #'b'
    ldy.z pscreen
    sty.z $fe
    ldy.z pscreen+1
    sty.z $ff
    ldy #0
    sta ($fe),y
    rts
}
