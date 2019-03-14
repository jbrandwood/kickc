// Example of inline kickasm data
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label sintab = $1000
main: {
    .label screen = 2
    .label cols = 4
    lda #<$d800
    sta cols
    lda #>$d800
    sta cols+1
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #0
  b1:
    ldy sintab,x
    lda #'*'
    sta (screen),y
    lda screen
    clc
    adc #$28
    sta screen
    bcc !+
    inc screen+1
  !:
    lda #1
    sta (cols),y
    lda cols
    clc
    adc #$28
    sta cols
    bcc !+
    inc cols+1
  !:
    inx
    cpx #$19
    bne b1
    rts
}
.pc = sintab "sintab"
  .fill 25, 20 + 20*sin(toRadians(i*360/25))

