.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const STAR = $51
  .const RED = 2
  .label SCREEN = $400
  .label VIC = $d000
main: {
    // *SCREEN = STAR
    lda #STAR
    sta SCREEN
    // *BG_COLOR = RED
    lda #RED
    sta VIC+$10*2+1
    ldx #$28
  __b1:
    // SCREEN[i] = (STAR+1)
    lda #STAR+1
    sta SCREEN,x
    // for(byte i: 40..79)
    inx
    cpx #$50
    bne __b1
    // }
    rts
}
