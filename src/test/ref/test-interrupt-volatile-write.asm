// Tests that volatile variables can be both read & written inside & outside interrupts
// Currently fails because the modification is optimized away
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label col = 2
__bbegin:
  // col = 0
  lda #0
  sta.z col
  jsr main
  rts
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  __b1:
    // if(col>10)
    lda.z col
    cmp #$a+1
    bcc __b1
    // col = 0
    lda #0
    sta.z col
    jmp __b1
}
irq: {
    // asm
    lda $dc0d
    // *BGCOL = col
    lda.z col
    sta BGCOL
    // if(col!=0)
    lda.z col
    cmp #0
    bne __b1
    // col += 2
    clc
    adc #2
    sta.z col
    // }
    jmp $ea81
  __b1:
    // col++;
    inc.z col
    jmp $ea81
}
