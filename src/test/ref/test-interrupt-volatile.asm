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
    inc.z col
    jmp __b2
}
irq: {
    lda $dc0d
    lda.z col
    sta BGCOL
    jmp $ea81
}
