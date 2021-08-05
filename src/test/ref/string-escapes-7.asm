// Test using some simple supported string escape
// Test escaping of quotes in chars and strings
  // Commodore 64 PRG executable file
.file [name="string-escapes-7.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const Q1 = '"'
  .const Q2 = '\''
  .label SCREEN = $400
.segment Code
main: {
    // SCREEN[40] = Q1
    lda #Q1
    sta SCREEN+$28
    // SCREEN[41] = Q2
    lda #Q2
    sta SCREEN+$29
    ldx #0
  __b1:
    // for(char i=0;S[i];i++)
    lda S,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i] = S[i]
    lda S,x
    sta SCREEN,x
    // for(char i=0;S[i];i++)
    inx
    jmp __b1
}
.segment Data
  S: .text @"\"'"
  .byte 0
