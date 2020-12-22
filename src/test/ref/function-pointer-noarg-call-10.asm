// Tests calling into different function pointers which call a common sub-method
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-10.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 7
.segment Code
__start: {
    // idx = 0
    lda #0
    sta.z idx
    jsr main
    rts
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
  .segment Data
    msg: .text "world "
    .byte 0
}
.segment Code
hello: {
    // print("hello ")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // }
    rts
  .segment Data
    msg: .text "hello "
    .byte 0
}
.segment Code
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
// print(byte* zp(2) msg)
print: {
    .label msg = 2
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
// do10(void()* zp(4) fn)
do10: {
    .label i = 6
    .label fn = 4
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
