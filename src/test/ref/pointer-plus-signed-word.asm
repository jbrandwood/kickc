// Test adding a signed word to a pointer
// Fragment pbuz1=pbuc1_plus_vwsz1.asm supplied by Richard-William Loerakker
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400+$28*$a
main: {
    .label sc = 4
    .label i = 2
    lda #<-$a
    sta.z i
    lda #>-$a
    sta.z i+1
  b1:
    lda #<SCREEN
    clc
    adc.z i
    sta.z sc
    lda #>SCREEN
    adc.z i+1
    sta.z sc+1
    lda.z i
    ldy #0
    sta (sc),y
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$b
    bne b1
    lda.z i
    cmp #<$b
    bne b1
    rts
}
