// Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
  // Commodore 64 PRG executable file
.file [name="local-string.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label screen = $400
    ldx #0
  __b1:
    // while(msg[i])
    lda msg,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // screen[i++] = msg[i]
    lda msg,x
    sta screen,x
    // screen[i++] = msg[i];
    inx
    jmp __b1
  .segment Data
    msg: .text "message 2 "
    .byte 0
}
