.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  //  Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  //  Blitter Source A Start
  .label DTV_BLITTER_SRCA_LO = $d320
  .label DTV_BLITTER_SRCA_MI = $d321
  .label DTV_BLITTER_SRCA_HI = $d322
  //  Blitter Source A Modulo
  .label DTV_BLITTER_SRCA_MOD_LO = $d323
  .label DTV_BLITTER_SRCA_MOD_HI = $d324
  //  Blitter Source A Line Length
  .label DTV_BLITTER_SRCA_LIN_LO = $d325
  .label DTV_BLITTER_SRCA_LIN_HI = $d326
  //  Blitter Source A Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_SRCA_STEP = $d327
  //  Blitter Source B Start
  .label DTV_BLITTER_SRCB_LO = $d328
  .label DTV_BLITTER_SRCB_MI = $d329
  .label DTV_BLITTER_SRCB_HI = $d32a
  //  Blitter Source B Modulo
  .label DTV_BLITTER_SRCB_MOD_LO = $d32b
  .label DTV_BLITTER_SRCB_MOD_HI = $d32c
  //  Blitter Source B Line Length
  .label DTV_BLITTER_SRCB_LIN_LO = $d32d
  .label DTV_BLITTER_SRCB_LIN_HI = $d32e
  //  Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_SRCB_STEP = $d32f
  //  Blitter Destination Start
  .label DTV_BLITTER_DEST_LO = $d330
  .label DTV_BLITTER_DEST_MI = $d331
  .label DTV_BLITTER_DEST_HI = $d332
  //  Blitter Source B Modulo
  .label DTV_BLITTER_DEST_MOD_LO = $d333
  .label DTV_BLITTER_DEST_MOD_HI = $d334
  //  Blitter Source B Line Length
  .label DTV_BLITTER_DEST_LIN_LO = $d335
  .label DTV_BLITTER_DEST_LIN_HI = $d336
  //  Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_DEST_STEP = $d337
  //  Blitter Blit Length
  .label DTV_BLITTER_LEN_LO = $d338
  .label DTV_BLITTER_LEN_HI = $d339
  //  Blitter Control
  .label DTV_BLITTER_CONTROL = $d33a
  //  Bit[0] Force Start Strobe when set
  .const DTV_BLIT_FORCE_START = 1
  //  Bit[1] Source A Direction Positive when set
  .const DTV_BLIT_SRCA_FWD = 2
  //  Bit[2] Source B Direction Positive when set
  .const DTV_BLIT_SRCB_FWD = 4
  //  Bit[3] Destination Direction Positive when set
  .const DTV_BLIT_DEST_FWD = 8
  //  Blitter Transparency
  .label DTV_BLITTER_TRANSPARANCY = $d33b
  //  No transparancy
  //  Bit[2]==Bit[1]==0: write in any case
  .const DTV_BLIT_TRANSPARANCY_NONE = 0
  //  Controls the ALU operation
  .label DTV_BLITTER_ALU = $d33e
  .const DTV_BLIT_ADD = $30
  //  Blitter Control 2
  .label DTV_BLITTER_CONTROL2 = $d33f
  //  Bit[0] Clear Blitter IRQ
  .const DTV_BLIT_CLEAR_IRQ = 1
  //  Bit[3] Destination Continue
  .const DTV_BLIT_DEST_CONT = 8
  //  Bit[0] Busy when set (When reading)
  .const DTV_BLIT_STATUS_BUSY = 1
  .label SCREEN = $400
  .const SRCA_LEN = 9
main: {
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    //  Instruct blitter not to continue previous blit
    lda #DTV_BLIT_CLEAR_IRQ
    sta DTV_BLITTER_CONTROL2
    lda #<SRCA
    sta DTV_BLITTER_SRCA_LO
    lda #>SRCA
    sta DTV_BLITTER_SRCA_MI
    lda #0
    sta DTV_BLITTER_SRCA_HI
    sta DTV_BLITTER_SRCA_MOD_LO
    sta DTV_BLITTER_SRCA_MOD_HI
    lda #<$100
    sta DTV_BLITTER_SRCA_LIN_LO
    lda #>$100
    sta DTV_BLITTER_SRCA_LIN_HI
    lda #$10
    sta DTV_BLITTER_SRCA_STEP
    //  Step 1.0
    lda #<SRCB
    sta DTV_BLITTER_SRCB_LO
    lda #>SRCB
    sta DTV_BLITTER_SRCB_MI
    lda #0
    sta DTV_BLITTER_SRCB_HI
    sta DTV_BLITTER_SRCB_MOD_LO
    sta DTV_BLITTER_SRCB_MOD_HI
    lda #<$100
    sta DTV_BLITTER_SRCB_LIN_LO
    lda #>$100
    sta DTV_BLITTER_SRCB_LIN_HI
    lda #0
    sta DTV_BLITTER_SRCB_STEP
    //  Step 0.0
    lda #<SCREEN
    sta DTV_BLITTER_DEST_LO
    lda #>SCREEN
    sta DTV_BLITTER_DEST_MI
    lda #0
    sta DTV_BLITTER_DEST_HI
    sta DTV_BLITTER_DEST_MOD_LO
    sta DTV_BLITTER_DEST_MOD_HI
    lda #<$100
    sta DTV_BLITTER_DEST_LIN_LO
    lda #>$100
    sta DTV_BLITTER_DEST_LIN_HI
    lda #$10
    sta DTV_BLITTER_DEST_STEP
    //  Step 1.0
    lda #SRCA_LEN
    sta DTV_BLITTER_LEN_LO
    lda #0
    sta DTV_BLITTER_LEN_HI
    lda #DTV_BLIT_ADD
    sta DTV_BLITTER_ALU
    lda #DTV_BLIT_TRANSPARANCY_NONE
    sta DTV_BLITTER_TRANSPARANCY
    //  Start blitter
    lda #DTV_BLIT_FORCE_START|DTV_BLIT_SRCA_FWD|DTV_BLIT_SRCB_FWD|DTV_BLIT_DEST_FWD
    sta DTV_BLITTER_CONTROL
    //  Instruct blitter to continue at DEST and restart SRC A/B
    lda #DTV_BLIT_DEST_CONT
    sta DTV_BLITTER_CONTROL2
    ldx #0
  //  wait til blitter is ready
  b2:
    lda DTV_BLITTER_CONTROL2
    and #DTV_BLIT_STATUS_BUSY
    cmp #0
    bne b2
    //  restart
    lda #DTV_BLIT_FORCE_START|DTV_BLIT_SRCA_FWD|DTV_BLIT_SRCB_FWD|DTV_BLIT_DEST_FWD
    sta DTV_BLITTER_CONTROL
    inx
    cpx #8
    bne b2
    rts
}
  SRCA: .byte 'c', 'a', 'm', 'e', 'l', 'o', 't', '!', ' '
  SRCB: .byte $80
