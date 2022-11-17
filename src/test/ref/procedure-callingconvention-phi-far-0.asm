// Test a procedure with calling convention stack
  // Commodore 64 PRG executable file
.file [name="procedure-callingconvention-phi-far-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    // plus('0', 7)
    .assert "Missing ASM fragment Fragment not found call_far_c64_entry. Attempted variations call_far_c64_entry ", 0, 1
    // SCREEN[0] = plus('0', 7)
    lda #plus.return
    sta SCREEN
    // }
    rts
}
// char plus(char a, char b)
plus: {
    .const a = '0'
    .const b = 7
    .label return = a+b
    rts
}
