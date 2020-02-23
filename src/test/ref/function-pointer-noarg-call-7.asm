// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 3
__b1:
  // idx = 0
  lda #0
  sta.z idx
  jsr main
  rts
main: {
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
    ldx #0
  __b1:
    // SCREEN[idx++] = msg[i++]
    lda msg,x
    ldy.z idx
    sta SCREEN,y
    // SCREEN[idx++] = msg[i++];
    inc.z idx
    inx
    // while(msg[i])
    lda msg,x
    cmp #0
    bne __b1
    // }
    rts
}
  msg: .text "hello "
  .byte 0
