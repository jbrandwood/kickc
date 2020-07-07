// Test a for() loop that runs forever
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
  __b1:
    // (*SCREEN)++;
    inc SCREEN
    jmp __b1
}
