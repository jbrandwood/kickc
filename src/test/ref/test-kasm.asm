.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .byte 1, 2, 3

//  Test inline KickAssembler code
main: {
  b2:
    inc $d020
        
    jmp b2
}
