.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label VECTOR_IRQ = $314
  jsr main
main: {
    .label FGCOL = $d021
    lda #<irq
    sta VECTOR_IRQ
    lda #>irq
    sta VECTOR_IRQ+1
  b2:
    inc FGCOL
    jmp b2
}
irq: {
    .label BGCOL = $d020
    inc BGCOL
    lda $dc0d
    pla
    tay
    pla
    tax
    pla
    rti
}
