// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label idx_ptr = idx
  .label SCREEN = $400
__bbegin:
  lda #0
  sta idx_ptr
  jsr main
  rts
main: {
    ldx #0
  __b1:
    lda idx_ptr
    sta SCREEN,x
    txa
    clc
    adc idx_ptr
    sta idx_ptr
    inx
    cpx #6
    bne __b1
    sta idx_ptr
    rts
}
  idx: .byte 0
