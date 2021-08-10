// Test effective live range and register allocation
// out::c should be a hardware register, main::i should be a hardware register, global idx should be a hardware register
  // Commodore 64 PRG executable file
.file [name="liverange-6.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldx #0
    ldy #0
  __b1:
    // out(msg[i])
    lda msg,y
    jsr out
    // for( byte i: 0..11)
    iny
    cpy #$c
    bne __b1
    // }
    rts
}
// void out(__register(A) char c)
out: {
    // SCREEN[idx++] = c
    sta SCREEN,x
    // SCREEN[idx++] = c;
    inx
    // }
    rts
}
.segment Data
  msg: .text "hello world!"
  .byte 0
