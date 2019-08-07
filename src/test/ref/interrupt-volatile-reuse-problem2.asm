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
  sta.z col1
  jsr main
  rts
main: {
    .label y = 2
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b4:
    ldx #0
  b1:
    lda #0
    sta.z y
  b2:
    ldy #0
  b3:
    tya
    clc
    adc.z y
    sta SCREEN,x
    iny
    cpy #$b
    bne b3
    inc.z y
    lda #$b
    cmp.z y
    bne b2
    inx
    cpx #$b
    bne b1
    jmp b4
}
irq: {
    // Acknowledge the IRQ
    lda #1
    sta IRQ_STATUS
    lda $dc0d
    lda.z col1
    sta SCREEN+$28
    inc.z col1
    jmp $ea81
}
