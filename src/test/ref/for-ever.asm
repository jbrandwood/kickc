// Test a for() loop that runs forever
  // Commodore 64 PRG executable file
.file [name="for-ever.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
  __b1:
    // (*SCREEN)++;
    inc SCREEN
    jmp __b1
}
