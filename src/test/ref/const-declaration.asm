// Tests a number of constant declarations
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const LINE_LEN = $28
  .const MARGIN_TOP = 4
  .const MARGIN_LEFT = 4
  .const OFFSET = $28*5+5
  .label SCREEN = $400
  .label BODY1 = SCREEN+MARGIN_TOP*LINE_LEN+MARGIN_LEFT
  .label BODY2 = SCREEN+OFFSET
main: {
    // *BODY1 = '*'
    lda #'*'
    sta BODY1
    // *BODY2 = '*'
    sta BODY2
    // }
    rts
}
