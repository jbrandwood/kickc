// Tests calling into a function pointer with local variables
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label msg = 3
  .label idx = 2
.segment Code
__start: {
    // byte* volatile msg
    lda #<0
    sta.z msg
    sta.z msg+1
    // byte volatile idx = 0
    sta.z idx
    jsr main
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
// void do10(void (*fn)())
do10: {
    .label i = 5
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
.segment Data
  msg1: .text "hello "
  .byte 0
  msg2: .text "world "
  .byte 0
