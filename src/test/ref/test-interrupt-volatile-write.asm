// Tests that volatile variables can be both read & written inside & outside interrupts
// Currently fails because the modification is optimized away
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label col = 2
__bbegin:
  lda #0
  sta.z col
  jsr main
  rts
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  __b2:
    lda.z col
    cmp #$a+1
    bcc __b2
    lda #0
    sta.z col
    jmp __b2
}
irq: {
    lda $dc0d
    lda.z col
    sta BGCOL
    lda.z col
    cmp #0
    bne __b1
    clc
    adc #2
    sta.z col
    jmp $ea81
  __b1:
    inc.z col
    jmp $ea81
}
