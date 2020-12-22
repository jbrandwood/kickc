  // Commodore 64 PRG executable file
.file [name="modglobal.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
  .label cnt = 2
.segment Code
main: {
    // inccnt()
    ldx #0
    ldy #0
    txa
    jsr inccnt
    // inccnt()
    // SCREEN[0]=inccnt()
    sta SCREEN
    // cnt++;
    lda.z cnt
    clc
    adc #1
    // inccnt()
    jsr inccnt
    // inccnt()
    // SCREEN[1]=inccnt()
    sta SCREEN+1
    // SCREEN[2]=cnt2
    sty SCREEN+2
    // SCREEN[3]=cnt3
    stx SCREEN+3
    // }
    rts
}
inccnt: {
    // ++cnt;
    clc
    adc #1
    sta.z cnt
    // ++cnt2;
    iny
    // ++cnt3;
    inx
    // return cnt;
    // }
    rts
}
