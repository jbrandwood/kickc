// Tests pointer plus 0 elimination
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label _0 = 2
    .label _2 = 2
    lda #<msg1
    sta first.return
    lda #>msg1
    sta first.return+1
    jsr first
    ldy #0
    lda (_0),y
    sta SCREEN
    lda #<msg2
    sta first.return
    lda #>msg2
    sta first.return+1
    jsr first
    ldy #0
    lda (_2),y
    sta SCREEN+1
    rts
}
first: {
    .label return = 2
    rts
}
  msg1: .text "hello world!"
  .byte 0
  msg2: .text "goodbye sky?"
  .byte 0
