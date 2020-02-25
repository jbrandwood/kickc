// Test inline KickAssembler code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // kickasm
  .byte 1, 2, 3

main: {
  __b1:
    // kickasm
    inc $d020
        
    jmp __b1
}
