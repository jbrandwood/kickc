// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label msg = 3
  .label idx = 5
__bbegin:
  // msg
  lda #<0
  sta.z msg
  sta.z msg+1
  // idx = 0
  sta.z idx
  jsr main
  rts
main: {
    // msg = msg1
    lda #<msg1
    sta.z msg
    lda #>msg1
    sta.z msg+1
    // do10(f)
    jsr do10
    // msg = msg2
    lda #<msg2
    sta.z msg
    lda #>msg2
    sta.z msg+1
    // do10(f)
    jsr do10
    // }
    rts
}
do10: {
    .label i = 2
    lda #0
    sta.z i
  __b1:
    // (*fn)()
    jsr hello
    // for( byte i: 0..9)
    inc.z i
    lda #$a
    cmp.z i
    bne __b1
    // }
    rts
}
hello: {
    ldy #0
  __b1:
    // SCREEN[idx++] = msg[i++]
    lda (msg),y
    ldx.z idx
    sta SCREEN,x
    // SCREEN[idx++] = msg[i++];
    inc.z idx
    iny
    // while(msg[i])
    lda (msg),y
    cmp #0
    bne __b1
    // }
    rts
}
  msg1: .text "hello "
  .byte 0
  msg2: .text "world "
  .byte 0
