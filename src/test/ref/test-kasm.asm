// Test inline KickAssembler code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .byte 1, 2, 3

main: {
  b1:
    inc $d020
        
    jmp b1
}
