.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label zpptr = $1000
    .label zpptr2 = 4
    .label w = 6
    .label i = 3
    .label j = 2
    lda #0
    sta j
  b1:
    lda #0
    sta i
  b2:
    ldx #0
  b3:
    lda i
    clc
    adc #<zpptr
    sta zpptr2
    lda #>zpptr
    adc #0
    sta zpptr2+1
    lda j
    sta w
    lda #0
    sta w+1
    lda zpptr2
    clc
    adc w
    sta zpptr2
    lda zpptr2+1
    adc w+1
    sta zpptr2+1
    txa
    ldy #0
    sta (zpptr2),y
    inx
    cpx #$b
    bne b3
    inc i
    lda #$b
    cmp i
    bne b2
    inc j
    cmp j
    bne b1
    rts
}
