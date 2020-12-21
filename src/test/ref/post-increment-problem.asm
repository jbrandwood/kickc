// Illustrates a problem with post-incrementing a pointer used in a loop comparison
  // Commodore 64 PRG executable file
.file [name="post-increment-problem.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label msg = 2
    lda #<MESSAGE
    sta.z msg
    lda #>MESSAGE
    sta.z msg+1
  // Error! The post-increment in the following loop is turned into a pre-increment by the compiler.
  __b1:
    // while(*msg++)
    ldy #0
    lda (msg),y
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    cmp #0
    bne __b1
    // *--msg = 'x';
    lda.z msg
    bne !+
    dec.z msg+1
  !:
    dec.z msg
    // *--msg = 'x'
    // Now msg should point right after the zero, since the post increment was executed in the last condition that evaluated to zero.
    lda #'x'
    ldy #0
    sta (msg),y
    // *++msg = 0;
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    // *++msg = 0
    lda #0
    tay
    sta (msg),y
    tax
  __b3:
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b4
    // }
    rts
  __b4:
    // SCREEN[i] = MESSAGE[i]
    lda MESSAGE,x
    sta SCREEN,x
    // i++;
    inx
    jmp __b3
}
.segment Data
  MESSAGE: .text "camelot"
  .byte 0
  .fill $c, 0
