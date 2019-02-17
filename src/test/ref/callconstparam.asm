// Multiple calls with different (constant?) parameters should yield different values at runtime
// Currently the same constant parameter is passed on every call.
// Reason: Multiple versioned parameter constants x0#0, x0#1 are only output as a single constant in the ASM .const x0 = 0
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 3
main: {
    lda #2
    sta line.x1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #1
    jsr line
    lda #5
    sta line.x1
    ldx #3
    jsr line
    rts
}
line: {
    .label x1 = 2
  b1:
    txa
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx x1
    bcc b1
    rts
}
