// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a pointer to a memory variable
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx_p = idx
main: {
    ldx #0
  __b1:
    lda idx_p
    sta SCREEN,x
    txa
    clc
    adc idx_p
    sta idx_p
    inx
    cpx #6
    bne __b1
    rts
}
  idx: .byte 0
