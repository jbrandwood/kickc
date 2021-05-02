  // Commodore 64 PRG executable file
.file [name="test-interrupt-volatile.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label KERNEL_IRQ = $314
  .label BG_COLOR = $d020
  .label col = 2
.segment Code
__start: {
    // volatile byte col = 0
    lda #0
    sta.z col
    jsr main
    rts
}
irq: {
    // asm
    lda $dc0d
    // *BG_COLOR = col
    lda.z col
    sta BG_COLOR
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
    // col++;
    inc.z col
    jmp __b1
}
