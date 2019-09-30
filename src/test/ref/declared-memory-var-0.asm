// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
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
    stx.z $ff
    clc
    adc.z $ff
    sta idx
    inx
    cpx #6
    bne __b1
    rts
}
  idx: .byte 0
