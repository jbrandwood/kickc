// Pointer to pointer to procedure - using typedef
  // Commodore 64 PRG executable file
.file [name="procedure-declare-9.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Use typedef to define const pointer to pointer to no-arg-noreturn procedure
  .label IRQ = $314
  .label SCREEN = $400
.segment Code
main: {
    // *IRQ = &irq
    lda #<irq
    sta IRQ
    lda #>irq
    sta IRQ+1
    // }
    rts
}
irq: {
    // SCREEN[0]++;
    inc SCREEN
    // }
    jmp $ea81
}
