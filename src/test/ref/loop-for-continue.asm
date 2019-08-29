// Tests continue statement in a simple for()-loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldy #0
    ldx #0
  b1:
    lda MESSAGE,x
    cmp #0
    bne b2
    rts
  b2:
    lda MESSAGE,x
    cmp #' '
    beq b4
    lda MESSAGE,x
    sta SCREEN,y
    iny
  b4:
    inx
    jmp b1
}
  MESSAGE: .text "hello brave new world!"
  .byte 0
