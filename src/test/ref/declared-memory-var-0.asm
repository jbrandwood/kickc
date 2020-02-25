// Test declaring a variable as "__mem __notssa", meaning it will be stored in memory and accessed through an implicit pointer (using load/store)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i] = idx
    lda idx
    sta SCREEN,x
    // idx +=i
    txa
    clc
    adc idx
    sta idx
    // for( char i: 0..5 )
    inx
    cpx #6
    bne __b1
    // }
    rts
}
  idx: .byte 0
