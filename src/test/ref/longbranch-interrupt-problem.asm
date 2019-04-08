// Tests that long branch fixing works with interrupt exits (to $ea81)
.pc = $801 "Basic"
:BasicUpstart(bbegin)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BGCOL = $d020
  .label col = 2
bbegin:
  lda #0
  sta col
  jsr main
  rts
main: {
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  b2:
    lda #$a
    cmp col
    bcs b2
    lda #0
    sta col
    jmp b2
}
irq: {
    lda $dc0d
    lda col
    sta BGCOL
    lda col
    cmp #0
    bne !_ea81+
    jmp $ea81
  !_ea81:
    inc col
    jmp $ea81
}
