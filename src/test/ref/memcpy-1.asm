// Test memcpy on strings (
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label sc = 6
    .label camelot = 4
    .label sc2 = 2
    .label reigns = 8
    ldx #0
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
    lda #<CAMELOT
    sta.z camelot
    lda #>CAMELOT
    sta.z camelot+1
  __b1:
    ldy #0
    lda (camelot),y
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z camelot
    bne !+
    inc.z camelot+1
  !:
    inx
    cpx #7
    bne __b1
    ldx #0
    lda #<SCREEN+$28
    sta.z sc2
    lda #>SCREEN+$28
    sta.z sc2+1
    lda #<reigns_1
    sta.z reigns
    lda #>reigns_1
    sta.z reigns+1
  __b2:
    ldy #0
    lda (reigns),y
    sta (sc2),y
    inc.z sc2
    bne !+
    inc.z sc2+1
  !:
    inc.z reigns
    bne !+
    inc.z reigns+1
  !:
    inx
    cpx #6
    bne __b2
    lda #<7
    sta.z memcpy.num
    lda #>7
    sta.z memcpy.num+1
    lda #<SCREEN+$a
    sta.z memcpy.destination
    lda #>SCREEN+$a
    sta.z memcpy.destination+1
    lda #<CAMELOT
    sta.z memcpy.source
    lda #>CAMELOT
    sta.z memcpy.source+1
    jsr memcpy
    lda #<5
    sta.z memcpy.num
    lda #>5
    sta.z memcpy.num+1
    lda #<SCREEN+$32
    sta.z memcpy.destination
    lda #>SCREEN+$32
    sta.z memcpy.destination+1
    lda #<__8
    sta.z memcpy.source
    lda #>__8
    sta.z memcpy.source+1
    jsr memcpy
    rts
    __8: .text "rules"
    .byte 0
    reigns_1: .text "reigns"
    .byte 0
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zeropage(6) destination, void* zeropage(4) source, word zeropage(8) num)
memcpy: {
    .label src_end = 8
    .label dst = 6
    .label src = 4
    .label source = 4
    .label destination = 6
    .label num = 8
    lda.z src_end
    clc
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
    sta.z src_end+1
  __b1:
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    rts
  __b2:
    ldy #0
    lda (src),y
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    inc.z src
    bne !+
    inc.z src+1
  !:
    jmp __b1
}
  CAMELOT: .text "camelot"
  .byte 0
