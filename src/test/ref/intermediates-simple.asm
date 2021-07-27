// Test intermediate vars
  // Commodore 64 PRG executable file
.file [name="intermediates-simple.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i = 2
    ldy #0
    tya
    sta.z i
  __b1:
    // for(char i=0;i<5;i++)
    lda.z i
    cmp #5
    bcc __b4
    // }
    rts
  __b4:
    ldx #0
  __b2:
    // for(char j=0;j<5;j++)
    cpx #5
    bcc __b3
    // for(char i=0;i<5;i++)
    inc.z i
    jmp __b1
  __b3:
    // char x = i+j
    txa
    clc
    adc.z i
    // SCREEN[idx++] = x
    sta SCREEN,y
    // SCREEN[idx++] = x;
    iny
    // char y = sum(i,j)
    lda.z i
    jsr sum
    // SCREEN[idx++] = y
    sta SCREEN,y
    // SCREEN[idx++] = y;
    iny
    // for(char j=0;j<5;j++)
    inx
    jmp __b2
}
// sum(byte register(A) a, byte register(X) b)
sum: {
    // a+b
    stx.z $ff
    clc
    adc.z $ff
    // }
    rts
}
