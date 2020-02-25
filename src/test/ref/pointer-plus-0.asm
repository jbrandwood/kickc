// Tests pointer plus 0 elimination
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label __0 = 2
    .label __2 = 2
    // first(msg1)
    lda #<msg1
    sta.z first.return
    lda #>msg1
    sta.z first.return+1
    jsr first
    // first(msg1)
    // SCREEN[0] = *(first(msg1)+0)
    ldy #0
    lda (__0),y
    sta SCREEN
    // first(msg2)
    lda #<msg2
    sta.z first.return
    lda #>msg2
    sta.z first.return+1
    jsr first
    // first(msg2)
    // SCREEN[1] = *(first(msg2)+0)
    ldy #0
    lda (__2),y
    sta SCREEN+1
    // }
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
