// Test compile-time and run-time multiplication
// var*const multiplication - converted to shift/add
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #0
  __b1:
    // for(char c1=0;c1<5;c1++)
    cpx #5
    bcc __b2
    // }
    rts
  __b2:
    // c3 = c1*c2
    txa
    asl
    stx.z $ff
    clc
    adc.z $ff
    asl
    stx.z $ff
    clc
    adc.z $ff
    // SCREEN[i++] = c3
    sta SCREEN,y
    // SCREEN[i++] = c3;
    iny
    // for(char c1=0;c1<5;c1++)
    inx
    jmp __b1
}
