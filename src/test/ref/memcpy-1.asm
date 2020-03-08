// Test memcpy on strings (
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // Working memory copy of string
    .label sc = 4
    .label camelot = 2
    .label sc2 = 8
    .label reigns = 6
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
    // *sc++ = *camelot++
    ldy #0
    lda (camelot),y
    sta (sc),y
    // *sc++ = *camelot++;
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    inc.z camelot
    bne !+
    inc.z camelot+1
  !:
    // for( char i: 0..6)
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
    // *sc2++ = *reigns++
    ldy #0
    lda (reigns),y
    sta (sc2),y
    // *sc2++ = *reigns++;
    inc.z sc2
    bne !+
    inc.z sc2+1
  !:
    inc.z reigns
    bne !+
    inc.z reigns+1
  !:
    // for( char i: 0..5)
    inx
    cpx #6
    bne __b2
    // memcpy(SCREEN+10, CAMELOT, 7)
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
    // memcpy(SCREEN+50, "rules", 5)
    lda #<5
    sta.z memcpy.num
    lda #>5
    sta.z memcpy.num+1
    lda #<SCREEN+$32
    sta.z memcpy.destination
    lda #>SCREEN+$32
    sta.z memcpy.destination+1
    lda #<__5
    sta.z memcpy.source
    lda #>__5
    sta.z memcpy.source+1
    jsr memcpy
    // }
    rts
    __5: .text "rules"
    .byte 0
    reigns_1: .text "reigns"
    .byte 0
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp($c) destination, void* zp($a) source, word zp($e) num)
memcpy: {
    .label src_end = $e
    .label dst = $c
    .label src = $a
    .label source = $a
    .label destination = $c
    .label num = $e
    // src_end = (char*)source+num
    lda.z src_end
    clc
    adc.z source
    sta.z src_end
    lda.z src_end+1
    adc.z source+1
    sta.z src_end+1
  __b1:
    // while(src!=src_end)
    lda.z src+1
    cmp.z src_end+1
    bne __b2
    lda.z src
    cmp.z src_end
    bne __b2
    // }
    rts
  __b2:
    // *dst++ = *src++
    ldy #0
    lda (src),y
    sta (dst),y
    // *dst++ = *src++;
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
