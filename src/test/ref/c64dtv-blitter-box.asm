// Fill a box on the screen using the blitter
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const DTV_FEATURE_ENABLE = 1
  // Bit[0] Force Start Strobe when set
  .const DTV_BLIT_FORCE_START = 1
  // Bit[1] Source A Direction Positive when set
  .const DTV_BLIT_SRCA_FWD = 2
  // Bit[2] Source B Direction Positive when set
  .const DTV_BLIT_SRCB_FWD = 4
  // Bit[3] Destination Direction Positive when set
  .const DTV_BLIT_DEST_FWD = 8
  // No transparancy
  // Bit[2]==Bit[1]==0: write in any case
  .const DTV_BLIT_TRANSPARANCY_NONE = 0
  .const DTV_BLIT_ADD = $30
  // Bit[0] Clear Blitter IRQ
  .const DTV_BLIT_CLEAR_IRQ = 1
  // Bit[3] Destination Continue
  .const DTV_BLIT_DEST_CONT = 8
  // Bit[0] Busy when set (When reading)
  .const DTV_BLIT_STATUS_BUSY = 1
  // Feature enables or disables the extra C64 DTV features
  .label DTV_FEATURE = $d03f
  // Blitter Source A Start
  .label DTV_BLITTER_SRCA_LO = $d320
  .label DTV_BLITTER_SRCA_MI = $d321
  .label DTV_BLITTER_SRCA_HI = $d322
  // Blitter Source A Modulo
  .label DTV_BLITTER_SRCA_MOD_LO = $d323
  .label DTV_BLITTER_SRCA_MOD_HI = $d324
  // Blitter Source A Line Length
  .label DTV_BLITTER_SRCA_LIN_LO = $d325
  .label DTV_BLITTER_SRCA_LIN_HI = $d326
  // Blitter Source A Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_SRCA_STEP = $d327
  // Blitter Source B Start
  .label DTV_BLITTER_SRCB_LO = $d328
  .label DTV_BLITTER_SRCB_MI = $d329
  .label DTV_BLITTER_SRCB_HI = $d32a
  // Blitter Source B Modulo
  .label DTV_BLITTER_SRCB_MOD_LO = $d32b
  .label DTV_BLITTER_SRCB_MOD_HI = $d32c
  // Blitter Source B Line Length
  .label DTV_BLITTER_SRCB_LIN_LO = $d32d
  .label DTV_BLITTER_SRCB_LIN_HI = $d32e
  // Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_SRCB_STEP = $d32f
  // Blitter Destination Start
  .label DTV_BLITTER_DEST_LO = $d330
  .label DTV_BLITTER_DEST_MI = $d331
  .label DTV_BLITTER_DEST_HI = $d332
  // Blitter Source B Modulo
  .label DTV_BLITTER_DEST_MOD_LO = $d333
  .label DTV_BLITTER_DEST_MOD_HI = $d334
  // Blitter Source B Line Length
  .label DTV_BLITTER_DEST_LIN_LO = $d335
  .label DTV_BLITTER_DEST_LIN_HI = $d336
  // Blitter Source B Step ([7:4] integral part, [3:0] fractional part)
  .label DTV_BLITTER_DEST_STEP = $d337
  // Blitter Blit Length
  .label DTV_BLITTER_LEN_LO = $d338
  .label DTV_BLITTER_LEN_HI = $d339
  // Blitter Control
  .label DTV_BLITTER_CONTROL = $d33a
  // Blitter Transparency
  .label DTV_BLITTER_TRANSPARANCY = $d33b
  // Blitter Control 2
  .label DTV_BLITTER_CONTROL2 = $d33f
  .label SCREEN = $400
  // Controls the ALU operation
  .label DTV_BLITTER_ALU = $d33e
main: {
    // *DTV_FEATURE = DTV_FEATURE_ENABLE
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
    // *DTV_BLITTER_CONTROL2 = DTV_BLIT_CLEAR_IRQ
    // Instruct blitter not to continue previous blit
    lda #DTV_BLIT_CLEAR_IRQ
    sta DTV_BLITTER_CONTROL2
    // *DTV_BLITTER_SRCA_LO = <SRCA
    lda #<SRCA
    sta DTV_BLITTER_SRCA_LO
    // *DTV_BLITTER_SRCA_MI = >SRCA
    lda #>SRCA
    sta DTV_BLITTER_SRCA_MI
    // *DTV_BLITTER_SRCA_HI = 0
    lda #0
    sta DTV_BLITTER_SRCA_HI
    // *DTV_BLITTER_SRCA_MOD_LO = 0
    sta DTV_BLITTER_SRCA_MOD_LO
    // *DTV_BLITTER_SRCA_MOD_HI = 0
    sta DTV_BLITTER_SRCA_MOD_HI
    // *DTV_BLITTER_SRCA_LIN_LO = <$100uw
    sta DTV_BLITTER_SRCA_LIN_LO
    // *DTV_BLITTER_SRCA_LIN_HI = >$100uw
    lda #>$100
    sta DTV_BLITTER_SRCA_LIN_HI
    // *DTV_BLITTER_SRCA_STEP = 01
    lda #1
    sta DTV_BLITTER_SRCA_STEP
    // *DTV_BLITTER_SRCB_LO = <SRCB
    // Step 0.0
    lda #<SRCB
    sta DTV_BLITTER_SRCB_LO
    // *DTV_BLITTER_SRCB_MI = >SRCB
    lda #>SRCB
    sta DTV_BLITTER_SRCB_MI
    // *DTV_BLITTER_SRCB_HI = 0
    lda #0
    sta DTV_BLITTER_SRCB_HI
    // *DTV_BLITTER_SRCB_MOD_LO = 0
    sta DTV_BLITTER_SRCB_MOD_LO
    // *DTV_BLITTER_SRCB_MOD_HI = 0
    sta DTV_BLITTER_SRCB_MOD_HI
    // *DTV_BLITTER_SRCB_LIN_LO = <$100uw
    sta DTV_BLITTER_SRCB_LIN_LO
    // *DTV_BLITTER_SRCB_LIN_HI = >$100uw
    lda #>$100
    sta DTV_BLITTER_SRCB_LIN_HI
    // *DTV_BLITTER_SRCB_STEP = $00
    lda #0
    sta DTV_BLITTER_SRCB_STEP
    // *DTV_BLITTER_DEST_LO = <SCREEN+40+5
    // Step 0.0
    lda #<SCREEN+$28+5
    sta DTV_BLITTER_DEST_LO
    // *DTV_BLITTER_DEST_MI = >SCREEN+40+5
    lda #>SCREEN+$28+5
    sta DTV_BLITTER_DEST_MI
    // *DTV_BLITTER_DEST_HI = 0
    lda #0
    sta DTV_BLITTER_DEST_HI
    // *DTV_BLITTER_DEST_MOD_LO = <21uw
    lda #<$15
    sta DTV_BLITTER_DEST_MOD_LO
    // *DTV_BLITTER_DEST_MOD_HI = >21uw
    lda #0
    sta DTV_BLITTER_DEST_MOD_HI
    // *DTV_BLITTER_DEST_LIN_LO = <19uw
    lda #<$13
    sta DTV_BLITTER_DEST_LIN_LO
    // *DTV_BLITTER_DEST_LIN_HI = >19uw
    lda #0
    sta DTV_BLITTER_DEST_LIN_HI
    // *DTV_BLITTER_DEST_STEP = $10
    lda #$10
    sta DTV_BLITTER_DEST_STEP
    // *DTV_BLITTER_LEN_LO = <20*10uw
    // Step 1.0
    lda #<$14*$a
    sta DTV_BLITTER_LEN_LO
    // *DTV_BLITTER_LEN_HI = >20*10uw
    lda #0
    sta DTV_BLITTER_LEN_HI
    // *DTV_BLITTER_ALU = DTV_BLIT_ADD
    lda #DTV_BLIT_ADD
    sta DTV_BLITTER_ALU
    // *DTV_BLITTER_TRANSPARANCY = DTV_BLIT_TRANSPARANCY_NONE
    lda #DTV_BLIT_TRANSPARANCY_NONE
    sta DTV_BLITTER_TRANSPARANCY
    // *DTV_BLITTER_CONTROL = DTV_BLIT_FORCE_START | DTV_BLIT_SRCA_FWD | DTV_BLIT_SRCB_FWD| DTV_BLIT_DEST_FWD
    // Start blitter
    lda #DTV_BLIT_FORCE_START|DTV_BLIT_SRCA_FWD|DTV_BLIT_SRCB_FWD|DTV_BLIT_DEST_FWD
    sta DTV_BLITTER_CONTROL
    // *DTV_BLITTER_CONTROL2 = DTV_BLIT_DEST_CONT
    // Instruct blitter to continue at DEST and restart SRC A/B
    lda #DTV_BLIT_DEST_CONT
    sta DTV_BLITTER_CONTROL2
  // wait til blitter is ready
  __b1:
    // *DTV_BLITTER_CONTROL2 & DTV_BLIT_STATUS_BUSY
    lda #DTV_BLIT_STATUS_BUSY
    and DTV_BLITTER_CONTROL2
    // while((*DTV_BLITTER_CONTROL2 & DTV_BLIT_STATUS_BUSY)!=0)
    cmp #0
    bne __b1
    // }
    rts
}
  SRCA: .text "camelot rules!"
  .byte 0
  SRCB: .byte $80
