.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label w = 2
    .label sw = 4
    lda #<0
    sta.z w
    sta.z w+1
  b1:
    lda.z w
    sta SCREEN
    lda.z w+1
    sta SCREEN+1
    inc.z w
    bne !+
    inc.z w+1
  !:
    lda.z w
    bne b1
    lda.z w+1
    bne b1
    lda #<-$7fff
    sta.z sw
    lda #>-$7fff
    sta.z sw+1
  b2:
    lda.z sw
    sta SCREEN+3
    lda.z sw+1
    sta SCREEN+4
    inc.z sw
    bne !+
    inc.z sw+1
  !:
    lda.z sw+1
    cmp #>$7fff
    bne b2
    lda.z sw
    cmp #<$7fff
    bne b2
    rts
}
