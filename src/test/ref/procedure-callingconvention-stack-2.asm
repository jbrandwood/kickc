// Test a procedure with calling convention stack - and enough parameters to use fast ASM for cleaning stack
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const STACK_BASE = $103
main: {
    .label _0 = 2
    lda #>$1234
    pha
    lda #<$1234
    pha
    lda #>$2345
    pha
    lda #<$2345
    pha
    jsr plus
    tsx
    txa
    axs #-4
    txs
    lda.z _0
    sta SCREEN
    lda.z _0+1
    sta SCREEN+1
    rts
}
// plus(word zeropage(4) a, word zeropage(6) b)
plus: {
    .const OFFSET_STACK_A = 0
    .const OFFSET_STACK_B = 2
    .label a = 4
    .label b = 6
    .label return = 4
    tsx
    lda STACK_BASE+OFFSET_STACK_A,x
    sta.z a
    lda STACK_BASE+OFFSET_STACK_A+1,x
    sta.z a+1
    tsx
    lda STACK_BASE+OFFSET_STACK_B,x
    sta.z b
    lda STACK_BASE+OFFSET_STACK_B+1,x
    sta.z b+1
    lda.z return
    clc
    adc.z b
    sta.z return
    lda.z return+1
    adc.z b+1
    sta.z return+1
    rts
}
