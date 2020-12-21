  // Commodore 64 PRG executable file
.file [name="helloworld2-inline.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = $400
.segment Code
main: {
    .label print22_at = screen+$50
    ldx #0
    ldy #0
  print21___b1:
    // for(byte i=0; msg[i]; i++)
    lda hello,y
    cmp #0
    bne print21___b2
    ldx #0
    ldy #0
  print22___b1:
    // for(byte i=0; msg[i]; i++)
    lda hello,y
    cmp #0
    bne print22___b2
    // }
    rts
  print22___b2:
    // at[j] = msg[i]
    lda hello,y
    sta print22_at,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print22___b1
  print21___b2:
    // at[j] = msg[i]
    lda hello,y
    sta screen,x
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    iny
    jmp print21___b1
  .segment Data
    hello: .text "hello world!"
    .byte 0
}
