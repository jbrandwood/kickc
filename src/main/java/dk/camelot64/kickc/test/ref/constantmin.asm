  .const SCREEN = $400
  .const STAR = $51
  .const VIC = $d000
  .const RED = $2
  .const BGCOL = VIC+$10*$2+$1
  jsr main
main: {
    lda #STAR
    sta SCREEN
    lda #RED
    sta BGCOL
    ldx #$28
  b1:
    lda #STAR+$1
    sta SCREEN,x
    inx
    cpx #$50
    bne b1
    rts
}
