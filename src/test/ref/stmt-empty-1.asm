// Test an empty statement ';'
  // Commodore 64 PRG executable file
.file [name="stmt-empty-1.prg", type="prg", segments="Program"]
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
    // for (; str[b] != 0; ++b)
    lda str,x
    cmp #0
    bne __b2
    // '0'+b
    txa
    axs #-['0']
    // SCREEN[0] = '0'+b
    // Empty body
    stx SCREEN
    // }
    rts
  __b2:
    // for (; str[b] != 0; ++b)
    inx
    jmp __b1
}
.segment Data
  str: .text "Hello!"
  .byte 0
