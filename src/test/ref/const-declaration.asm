// Tests a number of constant declarations
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const LINE_LEN = $28
  .const MARGIN_TOP = 4
  .const MARGIN_LEFT = 4
  .const OFFSET = $28*5+5
  .label BODY2 = SCREEN+OFFSET
main: {
    lda #'*'
    sta SCREEN+MARGIN_TOP*LINE_LEN+MARGIN_LEFT
    sta BODY2
    rts
}
