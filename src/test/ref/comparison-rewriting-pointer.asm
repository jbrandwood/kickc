// Test rewriting of constant comparisons for pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label screen = $400
    .label cols = $d800
    .label sc = 2
    .label cc = 2
    lda #<screen
    sta sc
    lda #>screen
    sta sc+1
  b1:
    lda #'a'
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>screen+$3e7
    bne !+
    lda sc
    cmp #<screen+$3e7
  !:
    bcc b1
    beq b1
    lda #<cols+$3e7
    sta cc
    lda #>cols+$3e7
    sta cc+1
  b2:
    lda #2
    ldy #0
    sta (cc),y
    lda cc
    bne !+
    dec cc+1
  !:
    dec cc
    lda #>cols-1
    cmp cc+1
    bcc b2
    bne !+
    lda #<cols-1
    cmp cc
    bcc b2
  !:
    rts
}
