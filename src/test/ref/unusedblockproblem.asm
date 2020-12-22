// Problem with eliminating unused blocks/vars after the infinite loop (symbol line#2 not removed from symbol table)
  // Commodore 64 PRG executable file
.file [name="unusedblockproblem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
  __b1:
    // (*SCREEN)++;
    inc SCREEN
    jmp __b1
}
