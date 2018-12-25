.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label DTV_FEATURE = $d03f
  .const DTV_FEATURE_ENABLE = 1
  .label DTV_BLITTER_SRCA_LO = $d320
  .label DTV_BLITTER_SRCA_MI = $d321
  .label DTV_BLITTER_SRCA_HI = $d322
  .label DTV_BLITTER_SRCA_MOD_LO = $d323
  .label DTV_BLITTER_SRCA_MOD_HI = $d324
  .label DTV_BLITTER_SRCA_LIN_LO = $d325
  .label DTV_BLITTER_SRCA_LIN_HI = $d326
  .label DTV_BLITTER_SRCA_STEP = $d327
  .label DTV_BLITTER_SRCB_LO = $d328
  .label DTV_BLITTER_SRCB_MI = $d329
  .label DTV_BLITTER_SRCB_HI = $d32a
  .label DTV_BLITTER_SRCB_MOD_LO = $d32b
  .label DTV_BLITTER_SRCB_MOD_HI = $d32c
  .label DTV_BLITTER_SRCB_LIN_LO = $d32d
  .label DTV_BLITTER_SRCB_LIN_HI = $d32e
  .label DTV_BLITTER_SRCB_STEP = $d32f
  .label DTV_BLITTER_DEST_LO = $d330
  .label DTV_BLITTER_DEST_MI = $d331
  .label DTV_BLITTER_DEST_HI = $d332
  .label DTV_BLITTER_DEST_MOD_LO = $d333
  .label DTV_BLITTER_DEST_MOD_HI = $d334
  .label DTV_BLITTER_DEST_LIN_LO = $d335
  .label DTV_BLITTER_DEST_LIN_HI = $d336
  .label DTV_BLITTER_DEST_STEP = $d337
  .label DTV_BLITTER_LEN_LO = $d338
  .label DTV_BLITTER_LEN_HI = $d339
  .label DTV_BLITTER_CONTROL = $d33a
  .const DTV_BLIT_FORCE_START = 1
  .const DTV_BLIT_SRCA_FWD = 2
  .const DTV_BLIT_SRCB_FWD = 4
  .const DTV_BLIT_DEST_FWD = 8
  .label DTV_BLITTER_TRANSPARANCY = $d33b
  .const DTV_BLIT_TRANSPARANCY_NONE = 0
  .label DTV_BLITTER_ALU = $d33e
  .const DTV_BLIT_ADD = $30
  .label DTV_BLITTER_CONTROL2 = $d33f
  .const DTV_BLIT_CLEAR_IRQ = 1
  .const DTV_BLIT_DEST_CONT = 8
  .const DTV_BLIT_STATUS_BUSY = 1
  .label SCREEN = $400
  .const SRCA_LEN = 9
main: {
    lda #DTV_FEATURE_ENABLE
    sta DTV_FEATURE
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
    lda #SRCA_LEN
    sta DTV_BLITTER_LEN_LO
    lda #0
    sta DTV_BLITTER_LEN_HI
    lda #DTV_BLIT_ADD
    sta DTV_BLITTER_ALU
    lda #DTV_BLIT_TRANSPARANCY_NONE
    sta DTV_BLITTER_TRANSPARANCY
    lda #DTV_BLIT_FORCE_START|DTV_BLIT_SRCA_FWD|DTV_BLIT_SRCB_FWD|DTV_BLIT_DEST_FWD
    sta DTV_BLITTER_CONTROL
    lda #DTV_BLIT_DEST_CONT
    sta DTV_BLITTER_CONTROL2
    ldx #0
  b2:
    lda DTV_BLITTER_CONTROL2
    and #DTV_BLIT_STATUS_BUSY
    cmp #0
    bne b2
    lda #DTV_BLIT_FORCE_START|DTV_BLIT_SRCA_FWD|DTV_BLIT_SRCB_FWD|DTV_BLIT_DEST_FWD
    sta DTV_BLITTER_CONTROL
    inx
    cpx #8
    bne b2
    rts
}
  SRCA: .byte 'c', 'a', 'm', 'e', 'l', 'o', 't', '!', ' '
  SRCB: .byte $80
