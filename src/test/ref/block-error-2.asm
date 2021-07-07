// Demonstrates error "Sequence does not contain all blocks from the program."
  // Commodore 64 PRG executable file
.file [name="block-error-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const move = 1
    ldx #1
    txa
  __b1:
    // pos += move
    clc
    adc #move
    // if(pos)
    cmp #0
    beq __b2
    ldx #0
  __b2:
    // while(pos && vacant)
    cmp #0
    beq __breturn
    cpx #0
    bne __b1
  __breturn:
    // }
    rts
}
