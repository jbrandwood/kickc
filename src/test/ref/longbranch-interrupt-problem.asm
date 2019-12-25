// Tests that long branch fixing works with interrupt exits (to $ea81)
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
  __b1:
    lda.z col
    cmp #$a+1
    bcc __b1
    lda #0
    sta.z col
    jmp __b1
}
irq: {
    lda $dc0d
    lda.z col
    sta BGCOL
    lda.z col
    cmp #0
    bne !__ea81+
    jmp $ea81
  !__ea81:
    inc.z col
    jmp $ea81
}
