// Test inline KickAssembler code
  // Commodore 64 PRG executable file
.file [name="test-kasm.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
  __b1:
    // kickasm
    // KickAsm inline code
    inc $d020
        
    jmp __b1
}
.segment Data
// KickAsm data initializer
A:
.byte 1, 2, 3

