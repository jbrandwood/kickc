// Test array index pointer rewriting
// 8bit array with 16bit index
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label i = 2
    .label __1 = 4
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned short i=0;i<NUM_ENTITIES;i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #$19
    bcc __b2
  !:
    // }
    rts
  __b2:
    // entities[i] = 7
    lda.z i
    clc
    adc #<entities
    sta.z __1
    lda.z i+1
    adc #>entities
    sta.z __1+1
    lda #7
    ldy #0
    sta (__1),y
    // for(unsigned short i=0;i<NUM_ENTITIES;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment Data
  entities: .fill $19, 0
