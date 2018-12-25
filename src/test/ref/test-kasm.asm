.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
bbegin:
  .byte 1, 2, 3

  jsr main
main: {
  b2:
    inc $d020
        
    jmp b2
}
