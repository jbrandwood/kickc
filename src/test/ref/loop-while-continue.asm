// Tests break statement in a simple loop
  // Commodore 64 PRG executable file
.file [name="loop-while-continue.prg", type="prg", segments="Program"]
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
    // while(++i<40*6)
    inx
    cpx #$28*6
    bcc __b2
    // }
    rts
  __b2:
    // if(SCREEN[i]==' ')
    lda SCREEN,x
    cmp #' '
    beq __b1
    // SCREEN[i]++;
    inc SCREEN,x
    jmp __b1
}
