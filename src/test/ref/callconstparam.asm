// Multiple calls with different (constant?) parameters should yield different values at runtime
// Currently the same constant parameter is passed on every call.
// Reason: Multiple versioned parameter constants x0#0, x0#1 are only output as a single constant in the ASM .const x0 = 0
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = 3
main: {
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #2
    sta.z line.x1
    ldx #1
    jsr line
    lda #5
    sta.z line.x1
    ldx #3
    jsr line
    rts
}
// line(byte zeropage(2) x1)
line: {
    .label x1 = 2
  b1:
    cpx.z x1
    bcc b2
    rts
  b2:
    txa
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    jmp b1
}
