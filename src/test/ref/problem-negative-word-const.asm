// Problem with assigning negative word constant (vwuz1=vbuc1)
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label w = 2
    ldx #0
  b1:
    txa
    and #1
    cmp #0
    beq b3
    lda #<-1
    sta w
    lda #>-1
    sta w+1
    jmp b2
  b3:
    txa
    sta w
    lda #0
    sta w+1
  b2:
    txa
    asl
    tay
    lda w
    sta screen,y
    lda w+1
    sta screen+1,y
    inx
    cpx #8
    bne b1
    rts
}