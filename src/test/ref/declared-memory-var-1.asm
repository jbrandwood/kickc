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
    // SCREEN[i] = *idx_p
    lda idx_p
    sta SCREEN,x
    // *idx_p +=i
    txa
    clc
    adc idx_p
    sta idx_p
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
  idx: .byte 0
