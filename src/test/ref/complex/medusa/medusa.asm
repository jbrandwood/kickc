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
  .label MEDUSA_SCREEN = $1000
  .label MEDUSA_COLORS = $1400
  .label SCREEN = $400
main: {
    lda #BLACK
    sta BGCOL
    lda #<SCREEN
    sta memcpy.destination
    lda #>SCREEN
    sta memcpy.destination+1
    lda #<MEDUSA_SCREEN
    sta memcpy.source
    lda #>MEDUSA_SCREEN
    sta memcpy.source+1
    jsr memcpy
    lda #<COLS
    sta memcpy.destination
    lda #>COLS
    sta memcpy.destination+1
    lda #<MEDUSA_COLORS
    sta memcpy.source
    lda #>MEDUSA_COLORS
    sta memcpy.source+1
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
    lda source
    clc
    adc #<$3e8
    sta src_end
    lda source+1
    adc #>$3e8
    sta src_end+1
  b1:
    lda src+1
    cmp src_end+1
    bne b2
    lda src
    cmp src_end
    bne b2
    rts
  b2:
    ldy #0
    lda (src),y
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    inc src
    bne !+
    inc src+1
  !:
    jmp b1
}
.pc = MEDUSA_SCREEN "MEDUSA_SCREEN"
  .var fileScreen = LoadBinary("medusas.prg", BF_C64FILE)
    .fill fileScreen.getSize(), fileScreen.get(i)

.pc = MEDUSA_COLORS "MEDUSA_COLORS"
  .var fileCols = LoadBinary("medusac.prg", BF_C64FILE)
    .fill fileCols.getSize(), fileCols.get(i)

