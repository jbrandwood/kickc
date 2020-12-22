// Classic for() does not allow assignment as increment, eg. for(byte i=0;i<40;i=i+2) {}
// The following should give a program rendering a char on every second char of the first line - but results in a syntax error
  // Commodore 64 PRG executable file
.file [name="forincrementassign.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    lda #0
  __b1:
    // for(byte i=0;i<40;i=i+2)
    cmp #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = i
    tax
    sta SCREEN,x
    // i=i+2
    clc
    adc #2
    jmp __b1
}
