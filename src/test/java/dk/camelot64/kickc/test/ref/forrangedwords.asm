.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    .label SCREEN = $400
    .label w = 2
    .label sw = 2
    lda #<0
    sta w
    sta w+1
  b1:
    lda w
    sta SCREEN+0
    lda w+1
    sta SCREEN+1
    inc w
    bne !+
    inc w+1
  !:
    lda w
    bne b1
    lda w+1
    bne b1
    lda #<-$7fff
    sta sw
    lda #>-$7fff
    sta sw+1
  b2:
    lda sw
    sta SCREEN+3
    lda sw+1
    sta SCREEN+4
    inc sw
    bne !+
    inc sw+1
  !:
    lda sw+1
    cmp #>$7fff
    bne b2
    lda sw
    cmp #<$7fff
    bne b2
    rts
}
