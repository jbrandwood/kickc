// Tests anonymous scopes inside functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BG_COLOR = $d021
main: {
    .const i = 0
    .const i1 = 1
    // *BG_COLOR = i
    lda #i
    sta BG_COLOR
    lda #i1
    sta BG_COLOR
    // }
    rts
}
