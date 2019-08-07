// Display  MEDUSA PETSCII by Buzz_clik
// https://csdb.dk/release/?id=178673
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d021
  // Color Ram
  .label COLS = $d800
  // The colors of the C64
  .const BLACK = 0
  .label SCREEN = $400
main: {
    lda #BLACK
    sta BGCOL
    lda #<SCREEN
    sta.z memcpy.destination
    lda #>SCREEN
    sta.z memcpy.destination+1
    lda #<MEDUSA_SCREEN
    sta.z memcpy.source
    lda #>MEDUSA_SCREEN
    sta.z memcpy.source+1
    jsr memcpy
    lda #<COLS
    sta.z memcpy.destination
    lda #>COLS
    sta.z memcpy.destination+1
    lda #<MEDUSA_COLORS
    sta.z memcpy.source
    lda #>MEDUSA_COLORS
    sta.z memcpy.source+1
    jsr memcpy
  b1:
    lda #$e
    eor SCREEN+$3e7
    sta SCREEN+$3e7
    jmp b1
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
// memcpy(void* zeropage(4) destination, void* zeropage(2) source)
memcpy: {
    .label src_end = 6
    .label dst = 4
    .label src = 2
    .label source = 2
    .label destination = 4
    lda.z source
    clc
    adc #<$3e8
    sta.z src_end
    lda.z source+1
    adc #>$3e8
    sta.z src_end+1
  b1:
    lda.z src+1
    cmp.z src_end+1
    bne b2
    lda.z src
    cmp.z src_end
    bne b2
    rts
  b2:
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
    jmp b1
}
MEDUSA_SCREEN:
.var fileScreen = LoadBinary("medusas.prg", BF_C64FILE)
    .fill fileScreen.getSize(), fileScreen.get(i)

MEDUSA_COLORS:
.var fileCols = LoadBinary("medusac.prg", BF_C64FILE)
    .fill fileCols.getSize(), fileCols.get(i)

