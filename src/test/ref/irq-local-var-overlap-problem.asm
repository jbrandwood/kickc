// Illustrates a problem where local variables inside an IRQ are assigned the same zeropage as a variable outside the IRQ
  // Commodore 64 PRG executable file
.file [name="irq-local-var-overlap-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const IRQ_RASTER = 1
  .const CIA_INTERRUPT_CLEAR = $7f
  .label KERNEL_IRQ = $314
  .label RASTER = $d012
  .label VIC_CONTROL = $d011
  .label IRQ_STATUS = $d019
  .label IRQ_ENABLE = $d01a
  .label BG_COLOR = $d020
  .label FGCOL = $d021
  .label CIA1_INTERRUPT = $dc0d
.segment Code
irq: {
    .label k = 4
    .label j = 3
    .label i = 2
    // (*BG_COLOR)++;
    inc BG_COLOR
    lda #0
    sta.z i
  __b1:
    lda #0
    sta.z j
  __b2:
    lda #0
    sta.z k
  __b3:
    // i+j
    lda.z i
    clc
    adc.z j
    // i+j+k
    clc
    adc.z k
    // *FGCOL = i+j+k
    sta FGCOL
    // sub_irq()
    jsr sub_irq
    // for( byte k: 0..10 )
    inc.z k
    lda #$b
    cmp.z k
    bne __b3
    // for( byte j: 0..10 )
    inc.z j
    cmp.z j
    bne __b2
    // for( byte i: 0..10 )
    inc.z i
    cmp.z i
    bne __b1
    // *IRQ_STATUS = IRQ_RASTER
    lda #IRQ_RASTER
    sta IRQ_STATUS
    // (*BG_COLOR)--;
    dec BG_COLOR
    // }
    jmp $ea81
}
main: {
    .label k = 7
    .label j = 6
    .label i = 5
    // asm
    sei
    // *CIA1_INTERRUPT = CIA_INTERRUPT_CLEAR
    // Disable CIA 1 Timer IRQ
    lda #CIA_INTERRUPT_CLEAR
    sta CIA1_INTERRUPT
    // *VIC_CONTROL &=$7f
    // Set raster line to $0fd
    lda #$7f
    and VIC_CONTROL
    sta VIC_CONTROL
    // *RASTER = $fd
    lda #$fd
    sta RASTER
    // *IRQ_ENABLE = IRQ_RASTER
    // Enable Raster Interrupt
    lda #IRQ_RASTER
    sta IRQ_ENABLE
    // *KERNEL_IRQ = &irq
    // Set the IRQ routine
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    // asm
    cli
  __b4:
    lda #0
    sta.z i
  __b1:
    lda #0
    sta.z j
  __b2:
    lda #0
    sta.z k
  __b3:
    // i+j
    lda.z i
    clc
    adc.z j
    // i+j+k
    clc
    adc.z k
    // *FGCOL = i+j+k
    sta FGCOL
    // sub_main()
    jsr sub_main
    // for( byte k: 0..10 )
    inc.z k
    lda #$b
    cmp.z k
    bne __b3
    // for( byte j: 0..10 )
    inc.z j
    cmp.z j
    bne __b2
    // for( byte i: 0..10 )
    inc.z i
    cmp.z i
    bne __b1
    jmp __b4
}
sub_irq: {
    .label i = 8
    lda #0
    sta.z i
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    // i+j
    txa
    clc
    adc.z i
    // i+j+k
    sty.z $ff
    clc
    adc.z $ff
    // *BG_COLOR = i+j+k
    sta BG_COLOR
    // for( byte k: 0..10 )
    iny
    cpy #$b
    bne __b3
    // for( byte j: 0..10 )
    inx
    cpx #$b
    bne __b2
    // for( byte i: 0..10 )
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
sub_main: {
    .label i = 9
    lda #0
    sta.z i
  __b1:
    ldx #0
  __b2:
    ldy #0
  __b3:
    // i+j
    txa
    clc
    adc.z i
    // i+j+k
    sty.z $ff
    clc
    adc.z $ff
    // *BG_COLOR = i+j+k
    sta BG_COLOR
    // for( byte k: 0..10 )
    iny
    cpy #$b
    bne __b3
    // for( byte j: 0..10 )
    inx
    cpx #$b
    bne __b2
    // for( byte i: 0..10 )
    inc.z i
    lda #$b
    cmp.z i
    bne __b1
    // }
    rts
}
