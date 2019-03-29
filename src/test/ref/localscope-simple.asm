// Tests anonymous scopes inside functions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
main: {
    .const i = 0
    .const i1 = 1
    lda #i
    sta BGCOL
    lda #i1
    sta BGCOL
    rts
}
