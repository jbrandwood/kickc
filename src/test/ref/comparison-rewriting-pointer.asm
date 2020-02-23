// Test rewriting of constant comparisons for pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label cols = $d800
    .label sc = 2
    .label cc = 4
    lda #<screen
    sta.z sc
    lda #>screen
    sta.z sc+1
  __b1:
    // for(byte* sc =screen;sc<=screen+999;sc++)
    lda.z sc+1
    cmp #>screen+$3e7
    bne !+
    lda.z sc
    cmp #<screen+$3e7
  !:
    bcc __b2
    beq __b2
    lda #<cols+$3e7
    sta.z cc
    lda #>cols+$3e7
    sta.z cc+1
  __b3:
    // for(byte* cc =cols+999;cc>cols-1;cc--)
    lda #>cols-1
    cmp.z cc+1
    bcc __b4
    bne !+
    lda #<cols-1
    cmp.z cc
    bcc __b4
  !:
    // }
    rts
  __b4:
    // *cc=2
    lda #2
    ldy #0
    sta (cc),y
    // for(byte* cc =cols+999;cc>cols-1;cc--)
    lda.z cc
    bne !+
    dec.z cc+1
  !:
    dec.z cc
    jmp __b3
  __b2:
    // *sc='a'
    lda #'a'
    ldy #0
    sta (sc),y
    // for(byte* sc =screen;sc<=screen+999;sc++)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp __b1
}
