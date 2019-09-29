// Test inline KickAssembler code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .byte 1, 2, 3

main: {
  __b1:
    inc $d020
        
    jmp __b1
}
