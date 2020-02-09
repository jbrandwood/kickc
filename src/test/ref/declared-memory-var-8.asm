// Test declaring a variable as "memory", meaning it will be stored in main memory
// Test a fixed main memory address __notssa variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = $1000
__bbegin:
  lda #0
  sta idx
  jsr main
  rts
main: {
    ldx #0
  __b1:
    lda idx
    sta SCREEN,x
    txa
    clc
    adc idx
    sta idx
    inx
    cpx #6
    bne __b1
    rts
}
