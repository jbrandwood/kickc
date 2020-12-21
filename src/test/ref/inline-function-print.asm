// TEst inlining a slightly complex print function (containing a loop)
  // Commodore 64 PRG executable file
.file [name="inline-function-print.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label print2_at = screen+2*$28
    ldx #0
    ldy #0
  print1___b1:
    // for(byte i=0; msg[i]; i++)
    lda hello,y
    cmp #0
    bne print1___b2
    ldx #0
    ldy #0
  print2___b1:
    // for(byte i=0; msg[i]; i++)
    lda hello,y
    cmp #0
    bne print2___b2
    // }
    rts
  print2___b2:
    // at[j] = msg[i]
    lda hello,y
    sta print2_at,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print2___b1
  print1___b2:
    // at[j] = msg[i]
    lda hello,y
    sta screen,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print1___b1
  .segment Data
    hello: .text "hello world!"
    .byte 0
}
