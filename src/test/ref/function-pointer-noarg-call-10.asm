// Tests calling into different function pointers which call a common sub-method
.pc = $801 "Basic"
:BasicUpstart(_start)
.pc = $80d "Program"
  .label SCREEN = $400
  .label idx = 7
_start: {
    // idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
}
main: {
    // do10(&hello)
    lda #<hello
    sta.z do10.fn
    lda #>hello
    sta.z do10.fn+1
    jsr do10
    // do10(&world)
    lda #<world
    sta.z do10.fn
    lda #>world
    sta.z do10.fn+1
    jsr do10
    // }
    rts
}
// do10(void()* zp(2) fn)
do10: {
    .label i = 4
    .label fn = 2
    lda #0
    sta.z i
  __b1:
    // (*fn)()
    jsr bi_fn
    // for( byte i: 0..9)
    inc.z i
    lda #$a
    cmp.z i
    bne __b1
    // }
    rts
  bi_fn:
    jmp (fn)
}
world: {
    // print("world ")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // }
    rts
    msg: .text "world "
    .byte 0
}
// print(byte* zp(5) msg)
print: {
    .label msg = 5
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
hello: {
    // print("hello ")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // }
    rts
    msg: .text "hello "
    .byte 0
}
