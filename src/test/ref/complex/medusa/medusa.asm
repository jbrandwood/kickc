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
    sta memcpy.dst
    lda #>SCREEN
    sta memcpy.dst+1
    lda #<MEDUSA_SCREEN
    sta memcpy.src
    lda #>MEDUSA_SCREEN
    sta memcpy.src+1
    jsr memcpy
    lda #<COLS
    sta memcpy.dst
    lda #>COLS
    sta memcpy.dst+1
    lda #<MEDUSA_COLORS
    sta memcpy.src
    lda #>MEDUSA_COLORS
    sta memcpy.src+1
    jsr memcpy
  b1:
    lda #$e
    eor SCREEN+$3e7
    sta SCREEN+$3e7
    jmp b1
}
// Copy block of memory (forwards)
// Copies the values of num bytes from the location pointed to by source directly to the memory block pointed to by destination.
memcpy: {
    .label src = 2
    .label dst = 4
    .label i = 6
    lda #0
    sta i
    sta i+1
  b1:
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
    inc i
    bne !+
    inc i+1
  !:
    lda i+1
    cmp #>$3e8
    bcc b1
    bne !+
    lda i
    cmp #<$3e8
    bcc b1
  !:
    rts
}
.pc = MEDUSA_SCREEN "MEDUSA_SCREEN"
  .var fileScreen = LoadBinary("medusas.prg", BF_C64FILE)
    .fill fileScreen.getSize(), fileScreen.get(i)

.pc = MEDUSA_COLORS "MEDUSA_COLORS"
  .var fileCols = LoadBinary("medusac.prg", BF_C64FILE)
    .fill fileCols.getSize(), fileCols.get(i)

