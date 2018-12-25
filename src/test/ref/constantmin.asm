.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STAR = $51
  .label VIC = $d000
  .const RED = 2
  .label BGCOL = VIC+$10*2+1
main: {
    lda #STAR
    sta SCREEN
    lda #RED
    sta BGCOL
    ldx #$28
  b1:
    lda #STAR+1
    sta SCREEN,x
    inx
    cpx #$50
    bne b1
    rts
}
