// TEst inlining a slightly complex print function (containing a loop)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label print2_at = screen+2*$28
    ldx #0
    ldy #0
  print1_b1:
    lda print1_msg,y
    sta screen,x
    inx
    inx
    iny
    lda print1_msg,y
    cmp #'@'
    bne print1_b1
    ldx #0
    ldy #0
  print2_b1:
    lda print1_msg,y
    sta print2_at,x
    inx
    inx
    iny
    lda print1_msg,y
    cmp #'@'
    bne print2_b1
    rts
    print1_msg: .text "hello world!@"
}
