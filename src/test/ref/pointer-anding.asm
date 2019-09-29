// Test binary ANDing pointers by Clay Cowgill
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .label __2 = 6
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
    ldy #0
    lda #<$55aa
    sta (pos_ptr),y
    iny
    lda #>$55aa
    sta (pos_ptr),y
    ldy #0
    lda (pos_ptr),y
    and #<$aa55
    sta.z __2
    iny
    lda (pos_ptr),y
    and #>$aa55
    sta.z __2+1
    lda.z __2
    ldy #0
    sta (vram_ptr),y
    inc.z vram_ptr
    bne !+
    inc.z vram_ptr+1
  !:
    ldy #1
    lda (pos_ptr),y
    // stores 0x00
    ldy #0
    sta (vram_ptr),y
    inc.z vram_ptr
    bne !+
    inc.z vram_ptr+1
  !:
    lda #SIZEOF_SIGNED_WORD
    clc
    adc.z pos_ptr
    sta.z pos_ptr
    bcc !+
    inc.z pos_ptr+1
  !:
    inx
    cpx #3
    bne __b1
    rts
}
