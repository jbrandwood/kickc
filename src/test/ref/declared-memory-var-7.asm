// Test declaring a variable as "memory", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
// Test a zeropage notregister variable
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 2
__bbegin:
  // idx
  lda #0
  sta.z idx
  jsr main
  rts
main: {
    ldx #0
  __b1:
    // SCREEN[i] = idx
    lda.z idx
    sta SCREEN,x
    // idx +=i
    txa
    clc
    adc.z idx
    sta.z idx
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
