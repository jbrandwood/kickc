// Results in infinite compile loop as the compiler keeps trying to remove the same (empty) alias
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #$ff
    tya
  __b2:
    clc
    adc #1
    stx.z $ff
    cmp.z $ff
    bcs __b3
    tax
  __b3:
    sta.z $ff
    cpy.z $ff
    bcs __b4
    tay
  __b4:
    stx SCREEN
    sty SCREEN+1
    sta SCREEN+2
    jmp __b2
}
