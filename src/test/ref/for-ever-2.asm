// Test a for() loop that runs forever
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // SCREEN[i]++;
    inc SCREEN,x
    // for (char i=0;;i++)
    inx
    jmp __b1
}
