// Find atan2(x, y) using the CORDIC method
// See http://bsvi.ru/uploads/CORDIC--_10EBA/cordic.pdf
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // The number of iterations performed during CORDIC atan2 calculation
  .const CORDIC_ITERATIONS = 8
  // Angles representing ATAN(0.5), ATAN(0.25), ATAN(0.125), ...
  .label CORDIC_ATAN2_ANGLES = $1000
// Populate cordic angles table
main: {
    .label x = 5
    .label screen = 3
    .label y = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    lda #0
    sta y
  b1:
    lda #0
    sta x
  b2:
    lda x
    sta atan2.x
    lda y
    sta atan2.y
    jsr atan2
    txa
    ldy x
    sta (screen),y
    inc x
    lda #$28
    cmp x
    bne b2
    clc
    adc screen
    sta screen
    bcc !+
    inc screen+1
  !:
    inc y
    lda #$19
    cmp y
    bne b1
    rts
}
// Find the atan2(x, y) - which is the angle of the line from (0,0) to (x,y)
// Finding the angle requires a binary search using CORDIC_ITERATIONS
// Returns the angle in hex-degrees (0=0, 128=PI, 256=2*PI)
// atan2(signed byte zeropage(7) x, signed byte zeropage(6) y)
atan2: {
    .label x = 7
    .label y = 6
    .label xd = 9
    .label i = 8
    ldx #0
    txa
    sta i
  b1:
    lda y
    cmp #0
    bne b2
  b3:
    rts
  b2:
    lda x
    ldy i
    cpy #0
    beq !e+
  !l:
    cmp #$80
    ror
    dey
    bne !l-
  !e:
    sta xd
    lda y
    ldy i
    cpy #0
    beq !e+
  !l:
    cmp #$80
    ror
    dey
    bne !l-
  !e:
    tay
    lda y
    cmp #0
    beq !+
    bpl b4
  !:
    tya
    eor #$ff
    sec
    adc x
    sta x
    lda y
    clc
    adc xd
    sta y
    txa
    ldx i
    sec
    sbc CORDIC_ATAN2_ANGLES,x
    tax
  b5:
    inc i
    lda #CORDIC_ITERATIONS+1
    cmp i
    beq b3
    jmp b1
  b4:
    tya
    clc
    adc x
    sta x
    lda y
    sec
    sbc xd
    sta y
    txa
    ldx i
    clc
    adc CORDIC_ATAN2_ANGLES,x
    tax
    jmp b5
}
.pc = CORDIC_ATAN2_ANGLES "CORDIC_ATAN2_ANGLES"
  .fill CORDIC_ITERATIONS, 256*atan(1/pow(2,i))/PI/2

