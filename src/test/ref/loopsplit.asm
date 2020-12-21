  // Commodore 64 PRG executable file
.file [name="loopsplit.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
.segment Code
main: {
    .label SCREEN = $400
    ldy #0
    ldx #$64
  __b1:
    // while(--i>0)
    dex
    cpx #0
    bne __b2
    // *SCREEN = s
    sty SCREEN
    // }
    rts
  __b2:
    // if(i>50)
    cpx #$32+1
    bcs __b4
    // s--;
    dey
    jmp __b1
  __b4:
    // s++;
    iny
    jmp __b1
}
