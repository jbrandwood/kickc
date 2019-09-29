// Example of inline kickasm data
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label sintab = $1000
main: {
    .label screen = 2
    .label cols = 4
    lda #<$d800
    sta.z cols
    lda #>$d800
    sta.z cols+1
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #0
  __b1:
    ldy sintab,x
    lda #'*'
    sta (screen),y
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    lda #1
    sta (cols),y
    lda #$28
    clc
    adc.z cols
    sta.z cols
    bcc !+
    inc.z cols+1
  !:
    inx
    cpx #$19
    bne __b1
    rts
}
.pc = sintab "sintab"
  .fill 25, 20 + 20*sin(toRadians(i*360/25))

