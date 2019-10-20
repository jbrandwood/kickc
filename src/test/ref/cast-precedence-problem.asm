// Tests that casting inside constants in the output handles precedence between cast and + correctly - should generate the following KA-expression ($ff & sumw>>1)+1
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .const min = $a
    .const max = $c8
    .label BGCOL = $d021
    .const sumw = min+max
    .const sumb = min+max
    .const midw = (sumw>>1)+1
    .const midb = (sumb>>1)+1
    lda #midw
    sta SCREEN
    lda #midb
    sta SCREEN+1
    lda SCREEN
    cmp SCREEN+1
    beq __b1
    lda #2
    sta BGCOL
    rts
  __b1:
    lda #5
    sta BGCOL
    rts
}
