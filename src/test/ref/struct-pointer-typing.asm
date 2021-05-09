  // Commodore 64 PRG executable file
.file [name="struct-pointer-typing.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_STRUCT_BLOCK = 6
  .const OFFSET_STRUCT_BLOCK_PREV = 4
  .const OFFSET_STRUCT_BLOCK_NEXT = 2
.segment Code
main: {
    .label ptr = 2
    lda #<blocks
    sta.z ptr
    lda #>blocks
    sta.z ptr+1
    ldx #0
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    // }
    rts
  __b2:
    // ptr2->next = ptr->next
    ldy #OFFSET_STRUCT_BLOCK_PREV
    lda (ptr),y
    sta.z $fe
    iny
    lda (ptr),y
    sta.z $ff
    ldy #OFFSET_STRUCT_BLOCK_NEXT
    lda (ptr),y
    sta ($fe),y
    iny
    lda (ptr),y
    sta ($fe),y
    // ptr++;
    lda #SIZEOF_STRUCT_BLOCK
    clc
    adc.z ptr
    sta.z ptr
    bcc !+
    inc.z ptr+1
  !:
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
.segment Data
  blocks: .fill 6*$a, 0
