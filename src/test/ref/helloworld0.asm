// Tests minimal hello world
  // Commodore 64 PRG executable file
.file [name="helloworld0.prg", type="prg", segments="Program"]
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
  __b1:
    // SCREEN[i] = msg[i]
    lda msg,x
    sta SCREEN,x
    // for( byte i: 0..11)
    inx
    cpx #$c
    bne __b1
    // }
    rts
}
.segment Data
  msg: .text "hello world!"
  .byte 0
