// Test some complex pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // RValue pointer expression (constant)
    .label screen = $400
    // Increment on a const named pointer
    .label BGCOL = $d020
    ldx #0
  // RValue pointer expression (variable)
  __b1:
    lda screen+$28,x
    sta screen,x
    inx
    cpx #$b
    bne __b1
    lda screen+$79
    sta screen+$51
    // LValue pointer expression (constant - directly)
    lda screen+$7a
    sta screen+$52
    ldx #0
  // LValue pointer expression (variable - directly)
  __b3:
    lda screen+$c8,x
    sta screen+$a0,x
    inx
    cpx #$b
    bne __b3
    inc $d020
    dec $d000+$21
    inc BGCOL
    rts
}
