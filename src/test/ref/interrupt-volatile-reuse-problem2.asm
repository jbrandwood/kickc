.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label IRQ_STATUS = $d019
  .label SCREEN = $400
  .label col1 = 2
  lda #0
  sta col1
  jsr main
main: {
    .label y = 2
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b1:
    ldx #0
  b4:
    lda #0
    sta y
  b5:
    ldy #0
  b6:
    tya
    clc
    adc y
    sta SCREEN,x
    iny
    cpy #$b
    bne b6
    inc y
    lda y
    cmp #$b
    bne b5
    inx
    cpx #$b
    bne b4
    jmp b1
}
irq: {
    lda #1
    sta IRQ_STATUS
    lda $dc0d
    lda col1
    sta SCREEN+$28
    inc col1
    jmp $ea81
}
