// Illustrates problem where volatiles reuse ZP addresses of other variables
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label IRQ_STATUS = $d019
  .label SCREEN = $400
  .label col1 = 3
__bbegin:
  // col1 = 0
  lda #0
  sta.z col1
  jsr main
  rts
main: {
    .label y = 2
    // *KERNEL_IRQ = &irq
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
    // a+y
    tya
    clc
    adc.z y
    // SCREEN[x] = a+y
    sta SCREEN,x
    // for (byte a:0..10)
    iny
    cpy #$b
    bne __b3
    // for(byte y: 0..10)
    inc.z y
    lda #$b
    cmp.z y
    bne __b2
    // for(byte x: 0..10)
    inx
    cpx #$b
    bne __b1
    jmp b1
}
irq: {
    // *IRQ_STATUS = 1
    // Acknowledge the IRQ
    lda #1
    sta IRQ_STATUS
    // asm
    lda $dc0d
    // SCREEN[40] = col1++
    lda.z col1
    sta SCREEN+$28
    // SCREEN[40] = col1++;
    inc.z col1
    // }
    jmp $ea81
}
