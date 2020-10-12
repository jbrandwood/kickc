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
  __b1:
    // sc = SCREEN + i
    clc
    lda.z i
    adc #<SCREEN
    sta.z sc
    lda.z i+1
    adc #>SCREEN
    sta.z sc+1
    // *sc = (char)i
    lda.z i
    ldy #0
    sta (sc),y
    // for (signed word i : -10..10 )
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$b
    bne __b1
    lda.z i
    cmp #<$b
    bne __b1
    // }
    rts
}
