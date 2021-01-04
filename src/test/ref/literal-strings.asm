// Tests literal strings with and without zero-termination
  // Commodore 64 PRG executable file
.file [name="literal-strings.prg", type="prg", segments="Program"]
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
    // (SCREEN+40)[i] = msgz[i]
    lda msgz,x
    sta SCREEN+$28,x
    // for( byte i:0..3)
    inx
    cpx #4
    bne __b1
    // }
    rts
}
.segment Data
  msgz: .text "cml"
  msg: .text "cml"
  .byte 0
