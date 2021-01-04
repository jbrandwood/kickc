// Test using some simple supported string escapes \r \f \n \' \"
  // Commodore 64 PRG executable file
.file [name="string-escapes-0.prg", type="prg", segments="Program"]
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
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = MESSAGE[i++]
    lda MESSAGE,x
    sta SCREEN,x
    // SCREEN[i] = MESSAGE[i++];
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text @"\r\f\n\"'\\"
  .byte 0
