// Tests that casting inside constants in the output handles precedence between cast and + correctly - should generate the following KA-expression ($ff & sumw>>1)+1
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .const min = $a
    .const max = $c8
    .const sumw = min+max
    .const sumb = min+max
    .const midw = (sumw>>1)+1
    .const midb = (sumb>>1)+1
    .label SCREEN = $400
    .label BGCOL = $d021
    // SCREEN[0] = midw
    lda #midw
    sta SCREEN
    // SCREEN[1] = midb
    lda #midb
    sta SCREEN+1
    // if(SCREEN[0]==SCREEN[1])
    lda SCREEN
    cmp SCREEN+1
    beq __b1
    // *BGCOL = 2
    lda #2
    sta BGCOL
    // }
    rts
  __b1:
    // *BGCOL = 5
    lda #5
    sta BGCOL
    rts
}
