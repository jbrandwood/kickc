.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label KERNEL_IRQ = $314
  .label BORDERCOL = $d021
  .label BGCOL = $d020
  .label col1 = 2
  .label col2 = 2
  lda #0
  sta col1
  lda #8
  sta col2
  jsr main
main: {
    .label SCREEN = $400
    .label row = 2
    .label asd = 3
    lda #0
    sta asd
    ldx #$20
    tay
    lda #$c
    sta row
  b1:
    inc row
    lda row
    sta SCREEN,y
    inx
    txa
    clc
    adc asd
    sta asd
    iny
    cpy #$b
    bne b1
    stx SCREEN
    sta SCREEN+1
    lda #<irq
    sta KERNEL_IRQ
    lda #>irq
    sta KERNEL_IRQ+1
    rts
}
irq: {
    lda $dc0d
    lda col1
    sta BGCOL
    inc col1
    lda col2
    sta BORDERCOL
    inc col2
    jmp $ea81
}
