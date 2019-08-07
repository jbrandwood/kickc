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
    sta.z j
  b1:
    lda #0
    sta.z i
  b2:
    ldx #0
  b3:
    lda.z i
    clc
    adc #<zpptr
    sta.z zpptr2
    lda #>zpptr
    adc #0
    sta.z zpptr2+1
    lda.z j
    sta.z w
    lda #0
    sta.z w+1
    lda.z zpptr2
    clc
    adc.z w
    sta.z zpptr2
    lda.z zpptr2+1
    adc.z w+1
    sta.z zpptr2+1
    txa
    ldy #0
    sta (zpptr2),y
    inx
    cpx #$b
    bne b3
    inc.z i
    lda #$b
    cmp.z i
    bne b2
    inc.z j
    cmp.z j
    bne b1
    rts
}
