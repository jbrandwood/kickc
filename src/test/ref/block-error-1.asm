// Demonstrates error "Block referenced, but not found in program."
  // Commodore 64 PRG executable file
.file [name="block-error-1.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .const move = 1
    ldx #0
  __b1:
    // for(char i=0;i!=8;i++)
    cpx #8
    bne __b4
    // }
    rts
  __b4:
    lda #1
  __b2:
    // pos += move
    clc
    adc #move
    // if(pos)
    cmp #0
    // while(pos && vacant)
    cmp #0
    bne __b2
    // for(char i=0;i!=8;i++)
    inx
    jmp __b1
}
