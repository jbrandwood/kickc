.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    .const min = $a
    .const max = $c8
    .label BGCOL = $d021
    .const sumw = min+max
    .const sumb = min+max
    .const midb = (sumb>>1)+1
    .const midw = (sumw>>1)+1
    lda #midw
    sta SCREEN+0
    lda #midb
    sta SCREEN+1
    ldx SCREEN+0
    tay
    stx $ff
    cpy $ff
    bne b1
    lda #5
    sta BGCOL
  breturn:
    rts
  b1:
    lda #2
    sta BGCOL
    jmp breturn
}
