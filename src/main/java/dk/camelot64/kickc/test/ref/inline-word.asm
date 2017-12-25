.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SCREEN = $400
  jsr main
main: {
    .label w = 3
    .label sc = 3
    .label l = 2
    ldx #0
  b1:
    lda #4
    sta l
  b2:
    lda his,x
    sta w+1
    lda l
    sta w
    ldy #0
    lda #'*'
    sta (sc),y
    inc l
    lda l
    cmp #8
    bne b2
    inx
    cpx #2
    bne b1
    rts
    his: .byte >SCREEN, >SCREEN+$100
}
