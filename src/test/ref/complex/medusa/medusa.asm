// Display  MEDUSA PETSCII by Buzz_clik
// https://csdb.dk/release/?id=178673
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The colors of the C64
  .const BLACK = 0
  .label BG_COLOR = $d021
  // Color Ram
  .label COLS = $d800
  .label SCREEN = $400
main: {
    // *BG_COLOR = BLACK
    lda #BLACK
    sta BG_COLOR
    // memcpy(SCREEN, MEDUSA_SCREEN, 1000)
    lda #<SCREEN
    sta.z memcpy.destination
    lda #>SCREEN
    sta.z memcpy.destination+1
    lda #<MEDUSA_SCREEN
    sta.z memcpy.source
    lda #>MEDUSA_SCREEN
    sta.z memcpy.source+1
    jsr memcpy
    // memcpy(COLS, MEDUSA_COLORS, 1000)
    lda #<COLS
    sta.z memcpy.destination
    lda #>COLS
    sta.z memcpy.destination+1
    lda #<MEDUSA_COLORS
    sta.z memcpy.source
    lda #>MEDUSA_COLORS
    sta.z memcpy.source+1
    jsr memcpy
  __b1:
    // (*(SCREEN+999)) ^= 0x0e
    lda #$e
    eor SCREEN+$3e7
    sta SCREEN+$3e7
    jmp __b1
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zp(4) destination, void* zp(2) source)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    // src_end = (char*)source+num
    clc
    lda.z source
    adc #<$3e8
    sta.z src_end
    lda.z source+1
    adc #>$3e8
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
MEDUSA_SCREEN:
.var fileScreen = LoadBinary("medusas.prg", BF_C64FILE)
    .fill fileScreen.getSize(), fileScreen.get(i)

MEDUSA_COLORS:
.var fileCols = LoadBinary("medusac.prg", BF_C64FILE)
    .fill fileCols.getSize(), fileCols.get(i)

