// Constant consolidation produces a byte* + byte* error
  // Commodore 64 PRG executable file
.file [name="consolidate-constant-problem-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label __2 = 2
    .label sc = 2
    ldx #0
  __b1:
    // for(char COLS=0;COLS<2;COLS++)
    cpx #2
    bcc __b2
    // }
    rts
  __b2:
    // COLS*4
    txa
    asl
    asl
    // SCREEN + COLS*4
    clc
    adc #<SCREEN
    sta.z __2
    lda #>SCREEN
    adc #0
    sta.z __2+1
    // char* sc = SCREEN + COLS*4 + 2
    lda #2
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    ldy #0
  __b3:
    // for(char i=0;i<4;i++)
    cpy #4
    bcc __b4
    // for(char COLS=0;COLS<2;COLS++)
    inx
    jmp __b1
  __b4:
    // sc[i] = COLS
    txa
    sta (sc),y
    // for(char i=0;i<4;i++)
    iny
    jmp __b3
}
