// Test inline KickAssembler code with PC location specification
  // Commodore 64 PRG executable file
.file [name="test-kasm-pc.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label BORDER_COLOR = $d020
    ldx #0
  __b2:
    // *BORDER_COLOR = TABLE[i++]
    lda TABLE,x
    sta BORDER_COLOR
    // *BORDER_COLOR = TABLE[i++];
    inx
    jmp __b2
}
.segment Data
.pc = $2000 "TABLE"
TABLE:
.byte 1, 2, 3

