// Tests that volatile variables can be both read & written inside & outside interrupts
// Currently fails because the modification is optimized away
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label col = 2
bbegin:
  lda #0
  sta.z col
  jsr main
  rts
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b2:
    lda.z col
    cmp #$a+1
    bcc b2
    lda #0
    sta.z col
    jmp b2
}
irq: {
    lda $dc0d
    lda.z col
    sta BGCOL
    lda.z col
    cmp #0
    bne b1
    clc
    adc #2
    sta.z col
    jmp $ea81
  b1:
    inc.z col
    jmp $ea81
}
