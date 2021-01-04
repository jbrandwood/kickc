// Test binary ANDing pointers by Clay Cowgill
  // Commodore 64 PRG executable file
.file [name="pointer-anding.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const SIZEOF_SIGNED_WORD = 2
.segment Code
main: {
    .label __0 = 6
    .label vram_ptr = 4
    .label pos_ptr = 2
    ldx #0
    lda #<$428
    sta.z vram_ptr
    lda #>$428
    sta.z vram_ptr+1
    lda #<$400
    sta.z pos_ptr
    lda #>$400
    sta.z pos_ptr+1
  __b1:
    // *pos_ptr=(int)0x55AA
    ldy #0
    lda #<$55aa
    sta (pos_ptr),y
    iny
    lda #>$55aa
    sta (pos_ptr),y
    // *pos_ptr&(int)0xAA55
    ldy #0
    lda (pos_ptr),y
    and #<$aa55
    sta.z __0
    iny
    lda (pos_ptr),y
    and #>$aa55
    sta.z __0+1
    // <(*pos_ptr&(int)0xAA55)
    lda.z __0
    // *vram_ptr++=<(*pos_ptr&(int)0xAA55)
    ldy #0
    sta (vram_ptr),y
    // *vram_ptr++=<(*pos_ptr&(int)0xAA55);
    inc.z vram_ptr
    bne !+
    inc.z vram_ptr+1
  !:
    // >*pos_ptr
    ldy #1
    lda (pos_ptr),y
    // *vram_ptr++=>*pos_ptr
    // stores 0x00
    ldy #0
    sta (vram_ptr),y
    // *vram_ptr++=>*pos_ptr;
    inc.z vram_ptr
    bne !+
    inc.z vram_ptr+1
  !:
    // pos_ptr++;
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z pos_ptr
    sta.z pos_ptr
    bcc !+
    inc.z pos_ptr+1
  !:
    // for( char i:0..2)
    inx
    cpx #3
    bne __b1
    // }
    rts
}
