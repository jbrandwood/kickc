// Illustrates problem where volatiles reuse ZP addresses of other variables
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label IRQ_STATUS = $d019
  .label SCREEN = $400
  .label col1 = 3
__bbegin:
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
  b1:
    ldx #0
  __b1:
    lda #0
    sta.z y
  __b2:
    ldy #0
  __b3:
    tya
    clc
    adc.z y
    sta SCREEN,x
    iny
    cpy #$b
    bne __b3
    inc.z y
    lda #$b
    cmp.z y
    bne __b2
    inx
    cpx #$b
    bne __b1
    jmp b1
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
