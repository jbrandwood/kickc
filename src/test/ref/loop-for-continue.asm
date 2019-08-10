// Tests continue statement in a simple for()-loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
    ldy #0
  b1:
    lda #0
    cmp MESSAGE,y
    bne b2
    rts
  b2:
    lda MESSAGE,y
    cmp #' '
    beq b4
    lda MESSAGE,y
    sta SCREEN,x
    inx
  b4:
    iny
    jmp b1
}
  MESSAGE: .text "hello brave new world!"
  .byte 0
