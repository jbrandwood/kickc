// Test declaring a variable as register on a specific ZP address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    rts
}
