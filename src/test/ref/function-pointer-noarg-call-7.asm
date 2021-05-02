// Tests calling into a function pointer with local variables
  // Commodore 64 PRG executable file
.file [name="function-pointer-noarg-call-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(__start)
  .label SCREEN = $400
  .label idx = 3
.segment Code
__start: {
    // volatile byte idx = 0
    lda #0
    sta.z idx
    jsr main
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
.segment Data
  msg: .text "hello "
  .byte 0
