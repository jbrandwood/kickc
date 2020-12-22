  // Commodore 64 PRG executable file
.file [name="test-interrupt.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d020
  .label FGCOL = $d021
.segment Code
irq: {
    // (*BG_COLOR)++;
    inc BG_COLOR
    // asm
    lda $dc0d
    // }
    jmp $ea81
}
main: {
    // *KERNEL_IRQ = &irq
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
  __b1:
    // (*FGCOL)++;
    inc FGCOL
    jmp __b1
}
