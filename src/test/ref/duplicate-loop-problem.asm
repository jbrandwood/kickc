// Duplicate Loop Problem from Richard-William Loerakker
// Resulted in infinite loop in loop depth analysis
  // Commodore 64 PRG executable file
.file [name="duplicate-loop-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label DC00 = $dc00
.segment Code
main: {
  __b1:
    // key = *DC00
    ldx DC00
    // key & %00011111
    txa
    and #$1f
    // while(key == 0 && ((key & %00011111) == %00011111))
    cpx #0
    bne __b1
    cmp #$1f
    beq __b1
    jmp __b1
}
