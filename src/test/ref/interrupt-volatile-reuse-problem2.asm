// Illustrates problem where volatiles reuse ZP addresses of other variables
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label IRQ_STATUS = $d019
  .label SCREEN = $400
  .label col1 = 3
bbegin:
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
  b6:
    lda #0
    sta y
  b7:
    ldy #0
  b8:
    tya
    clc
    adc y
    sta SCREEN,x
    iny
    cpy #$b
    bne b8
    inc y
    lda #$b
    cmp y
    bne b7
    inx
    cpx #$b
    bne b6
    jmp b1
}
irq: {
    // Acknowledge the IRQ
    lda #1
    sta IRQ_STATUS
    lda $dc0d
    lda col1
    sta SCREEN+$28
    inc col1
    jmp $ea81
}
