.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label w = 3
    .label h = 2
    lda #0
    sta h
  // constant array
  b1:
    ldx #4
  b2:
    ldy h
    lda his,y
    sta w+1
    stx w
    lda #'*'
    ldy #0
    sta (w),y
    inx
    cpx #8
    bne b2
    inc h
    lda #3
    cmp h
    bne b1
    rts
    his: .byte >SCREEN, >SCREEN+$100, >SCREEN+$200
}
