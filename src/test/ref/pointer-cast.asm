// Tests casting pointer types to other pointer types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label ub_screen = $400
  .label sb_screen = $428
  .label uw_screen = $450
  .label sw_screen = $478
  .const ub = $29
  .const sb = -$29
  .const uw = $3000
  .const sw = -$3000
main: {
    lda #ub
    sta ub_screen
    lda #sb
    sta ub_screen+1
    lda #<uw
    sta ub_screen+2
    lda #>uw
    sta ub_screen+2+1
    lda #<sw
    sta ub_screen+4
    lda #>sw
    sta ub_screen+4+1
    lda #ub
    sta sb_screen
    lda #sb
    sta sb_screen+1
    lda #<uw
    sta sb_screen+2
    lda #>uw
    sta sb_screen+2+1
    lda #<sw
    sta sb_screen+4
    lda #>sw
    sta sb_screen+4+1
    lda #ub
    sta uw_screen
    lda #sb
    sta uw_screen+1
    lda #<uw
    sta uw_screen+2
    lda #>uw
    sta uw_screen+2+1
    lda #<sw
    sta uw_screen+4
    lda #>sw
    sta uw_screen+4+1
    lda #ub
    sta sw_screen
    lda #sb
    sta sw_screen+1
    lda #<uw
    sta sw_screen+2
    lda #>uw
    sta sw_screen+2+1
    lda #<sw
    sta sw_screen+4
    lda #>sw
    sta sw_screen+4+1
    rts
}
