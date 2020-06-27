// Test inline KickAssembler code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
  __b1:
    // kickasm
    // KickAsm inline code
    inc $d020
        
    jmp __b1
}
// KickAsm data initializer
A:
.byte 1, 2, 3

