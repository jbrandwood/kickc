// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486
  // Commodore 64 PRG executable file
.file [name="post-increment-problem-4.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label s = 2
    ldx #0
    lda #<MESSAGE
    sta.z s
    lda #>MESSAGE
    sta.z s+1
  __b1:
    // while(c=*s++)
    ldy #0
    lda (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = c
    sta SCREEN,x
    // SCREEN[i++] = c;
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text "hello world!"
  .byte 0
