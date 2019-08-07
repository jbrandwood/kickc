// Tests that array-indexing by a word variable is turned into pointer addition
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label i = 2
    .label _1 = 4
    lda #<0
    sta.z i
    sta.z i+1
  b2:
    lda.z i
    clc
    adc #<screen
    sta.z _1
    lda.z i+1
    adc #>screen
    sta.z _1+1
    lda #'a'
    ldy #0
    sta (_1),y
    lda #$28
    clc
    adc.z i
    sta.z i
    bcc !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$3e8
    bcc b2
    bne !+
    lda.z i
    cmp #<$3e8
    bcc b2
  !:
    rts
}
