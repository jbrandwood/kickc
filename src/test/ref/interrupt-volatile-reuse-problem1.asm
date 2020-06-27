// Illustrates problem where volatiles reuse the same ZP addresses for multiple overlapping volatiles
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label SCREEN = $400
  .label col1 = 2
  .label col2 = 3
_start: {
    // col1 = 0
    lda #0
    sta.z col1
    // col2 = 8
    lda #8
    sta.z col2
    jsr main
    rts
}
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // }
    rts
}
irq: {
    // SCREEN[40] = col1++
    lda.z col1
    sta SCREEN+$28
    // SCREEN[40] = col1++;
    inc.z col1
    // SCREEN[41] = col2++
    lda.z col2
    sta SCREEN+$29
    // SCREEN[41] = col2++;
    inc.z col2
    // }
    jmp $ea81
}
