// Tests that long branch fixing works with interrupt exits (to $ea81)
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
    bne !__ea81+
    jmp $ea81
  !__ea81:
    // col++;
    inc.z col
    // }
    jmp $ea81
}
