// Test array index pointer rewriting
// 8bit array with 8bit  index
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    ldx #0
  __b1:
    // for(char i=0;i<NUM_ENTITIES;i++)
    cpx #$19
    bcc __b2
    // }
    rts
  __b2:
    // entities[i] = 7
    lda #7
    sta entities,x
    // for(char i=0;i<NUM_ENTITIES;i++)
    inx
    jmp __b1
}
.segment Data
  entities: .fill $19, 0
