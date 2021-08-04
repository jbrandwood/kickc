// Test using some simple supported string escape
// Uses \0 to add null-characters
  // Commodore 64 PRG executable file
.file [name="string-escapes-6.prg", type="prg", segments="Program"]
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
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b3
    // SCREEN[i] = ' '
    lda #' '
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
  __b3:
    // SCREEN[i] = MESSAGE[i]
    lda MESSAGE,x
    sta SCREEN,x
    // i++;
    inx
    jmp __b2
}
.segment Data
  MESSAGE: .text @"a\$00bb\$00ccc\$00"
  .byte 0
