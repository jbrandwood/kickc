// Test removal of empty function
// main() should not be removed!
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // }
    rts
}
