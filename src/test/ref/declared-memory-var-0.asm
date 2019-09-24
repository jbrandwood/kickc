// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    txa
  b1:
    sta SCREEN,x
    stx.z $ff
    clc
    adc.z $ff
    inx
    cpx #6
    bne b1
    rts
}
