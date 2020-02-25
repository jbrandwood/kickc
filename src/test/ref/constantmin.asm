.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STAR = $51
  .label VIC = $d000
  .const RED = 2
main: {
    // *SCREEN = STAR
    lda #STAR
    sta SCREEN
    // *BGCOL = RED
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
