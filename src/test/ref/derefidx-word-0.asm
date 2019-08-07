// Tests that array-indexing by a word variable is turned into pointer addition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label i = 2
    .label _1 = 4
    lda #<0
    sta i
    sta i+1
  b1:
    lda i+1
    cmp #>$3e8
    bcc b2
    bne !+
    lda i
    cmp #<$3e8
    bcc b2
  !:
    rts
  b2:
    lda i
    clc
    adc #<screen
    sta _1
    lda i+1
    adc #>screen
    sta _1+1
    lda #'a'
    ldy #0
    sta (_1),y
    lda #$28
    clc
    adc i
    sta i
    bcc !+
    inc i+1
  !:
    jmp b1
}
