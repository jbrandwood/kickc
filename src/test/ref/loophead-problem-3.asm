// Program where loop-head optimization produces wrong return value
// Reported by Richard-William Loerakker
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BORDERCOL = $d020
  .label BGCOL = $d021
main: {
    .label result = 2
    .label kaputt = $a
    jsr mul16u
    lda.z result
    sta.z kaputt
    lda.z result+1
    sta.z kaputt+1
    lda.z kaputt
    sta BORDERCOL
    lda.z kaputt+1
    sta BGCOL
    rts
}
// Perform binary multiplication of two unsigned 16-bit words into a 32-bit unsigned double word
// mul16u(word zp($a) a)
mul16u: {
    .const b = $7b
    .label a = $a
    .label mb = 6
    .label res = 2
    .label return = 2
    lda #<b
    sta.z mb
    lda #>b
    sta.z mb+1
    lda #<b>>$10
    sta.z mb+2
    lda #>b>>$10
    sta.z mb+3
    lda #0
    sta.z res
    sta.z res+1
    sta.z res+2
    sta.z res+3
    lda #<4
    sta.z a
    lda #>4
    sta.z a+1
  __b1:
    lda.z a
    bne __b2
    lda.z a+1
    bne __b2
    rts
  __b2:
    lda #1
    and.z a
    cmp #0
    beq __b3
    lda.z res
    clc
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
    lda.z res+2
    adc.z mb+2
    sta.z res+2
    lda.z res+3
    adc.z mb+3
    sta.z res+3
  __b3:
    lsr.z a+1
    ror.z a
    asl.z mb
    rol.z mb+1
    rol.z mb+2
    rol.z mb+3
    jmp __b1
}
