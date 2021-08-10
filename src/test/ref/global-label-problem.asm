// Demonstrates problems with local labels overwriting global labels
// This should produce "abca" - but produces "abcc" because the local variable containing "c" overrides the global variable containing "a"
  // Commodore 64 PRG executable file
.file [name="global-label-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  // Screen pointer and index
  .label SCREEN = $400
.segment Code
main: {
    // print("a")
    ldx #0
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // print("b")
    lda #<msg1
    sta.z print.msg
    lda #>msg1
    sta.z print.msg+1
    jsr print
    // print1()
    jsr print1
    // }
    rts
  .segment Data
    msg1: .text "b"
    .byte 0
}
.segment Code
// void print(__zp(2) char *msg)
print: {
    .label msg = 2
  __b1:
    // while(*msg)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[idx++] = *msg++
    ldy #0
    lda (msg),y
    sta SCREEN,x
    // SCREEN[idx++] = *msg++;
    inx
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    jmp __b1
}
print1: {
    // print("c")
    lda #<msg
    sta.z print.msg
    lda #>msg
    sta.z print.msg+1
    jsr print
    // print("a")
    lda #<@msg
    sta.z print.msg
    lda #>@msg
    sta.z print.msg+1
    jsr print
    // }
    rts
  .segment Data
    msg: .text "c"
    .byte 0
}
  msg: .text "a"
  .byte 0
