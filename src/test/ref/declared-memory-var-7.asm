// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a zeropage notregister variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 2
__bbegin:
  lda #0
  sta.z idx
  jsr main
  rts
main: {
    ldx #0
  __b1:
    lda.z idx
    sta SCREEN,x
    txa
    clc
    adc.z idx
    sta.z idx
    inx
    cpx #6
    bne __b1
    rts
}
