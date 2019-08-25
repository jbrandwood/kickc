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
  b1:
    lda.z sc+1
    cmp #>screen+$3e7
    bne !+
    lda.z sc
    cmp #<screen+$3e7
  !:
    bcc b2
    beq b2
    lda #<cols+$3e7
    sta.z cc
    lda #>cols+$3e7
    sta.z cc+1
  b3:
    lda #>cols-1
    cmp.z cc+1
    bcc b4
    bne !+
    lda #<cols-1
    cmp.z cc
    bcc b4
  !:
    rts
  b4:
    lda #2
    ldy #0
    sta (cc),y
    lda.z cc
    bne !+
    dec.z cc+1
  !:
    dec.z cc
    jmp b3
  b2:
    lda #'a'
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    jmp b1
}
