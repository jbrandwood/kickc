// Test array index pointer rewriting
// 16bit array with 8bit index
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-1.prg", type="prg", segments="Program"]
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
    txa
    asl
    tay
    lda #7
    sta entities,y
    lda #0
    sta entities+1,y
    // for(char i=0;i<NUM_ENTITIES;i++)
    inx
    jmp __b1
}
.segment Data
  entities: .fill 2*$19, 0
