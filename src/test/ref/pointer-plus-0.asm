// Tests pointer plus 0 elimination
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label _1 = 2
    .label _3 = 2
    lda #<msg1
    sta first.msg
    lda #>msg1
    sta first.msg+1
    jsr first
    ldy #0
    lda (_1),y
    sta SCREEN
    lda #<msg2
    sta first.msg
    lda #>msg2
    sta first.msg+1
    jsr first
    ldy #0
    lda (_3),y
    sta SCREEN+1
    rts
}
// first(byte* zeropage(2) msg)
first: {
    .label return = 2
    .label msg = 2
    rts
}
  msg1: .text "hello world!@"
  msg2: .text "goodbye sky?@"
