// Tests continue statement in a simple for()-loop
  // Commodore 64 PRG executable file
.file [name="loop-for-continue.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    ldy #0
    ldx #0
  __b1:
    // for( char i =0; MESSAGE[i]; i++)
    lda MESSAGE,x
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // if(MESSAGE[i]==' ')
    lda MESSAGE,x
    cmp #' '
    beq __b4
    // SCREEN[idx++] = MESSAGE[i]
    lda MESSAGE,x
    sta SCREEN,y
    // SCREEN[idx++] = MESSAGE[i];
    iny
  __b4:
    // for( char i =0; MESSAGE[i]; i++)
    inx
    jmp __b1
}
.segment Data
  MESSAGE: .text "hello brave new world!"
  .byte 0
