// Test some complex pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // RValue pointer expression (constant)
    .label screen = $400
    // Increment on a const named pointer
    .label BGCOL = $d020
    .label sc2 = screen+$51
    .label _15 = 2
    .label _18 = 2
    .label _20 = 4
    ldx #0
  // RValue pointer expression (variable)
  b1:
    txa
    clc
    adc #<screen+$28
    sta _15
    lda #>screen+$28
    adc #0
    sta _15+1
    ldy #0
    lda (_15),y
    sta screen,x
    inx
    cpx #$b
    bne b1
    lda screen+$79
    sta sc2
    // LValue pointer expression (constant - directly)
    lda screen+$7a
    sta screen+$52
    ldx #0
  // LValue pointer expression (variable - directly)
  b3:
    txa
    clc
    adc #<screen+$a0
    sta _18
    lda #>screen+$a0
    adc #0
    sta _18+1
    txa
    clc
    adc #<screen+$c8
    sta _20
    lda #>screen+$c8
    adc #0
    sta _20+1
    ldy #0
    lda (_20),y
    sta (_18),y
    inx
    cpx #$b
    bne b3
    inc $d020
    dec $d000+$21
    inc BGCOL
    rts
}
