// Minimal union with C-Standard behavior - array of union
  // Commodore 64 PRG executable file
.file [name="union-3.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label __1 = 2
    ldx #0
  __b1:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b2
    ldx #0
  __b3:
    // for(char i=0;i<10;i++)
    cpx #$a
    bcc __b4
    // }
    rts
  __b4:
    // SCREEN[i] = datas[i].b
    txa
    asl
    tay
    lda datas,y
    sta SCREEN,x
    // for(char i=0;i<10;i++)
    inx
    jmp __b3
  __b2:
    // 0x1230+i
    txa
    clc
    adc #<$1230
    sta.z __1
    lda #>$1230
    adc #0
    sta.z __1+1
    // datas[i].w = 0x1230+i
    txa
    asl
    tay
    lda.z __1
    sta datas,y
    lda.z __1+1
    sta datas+1,y
    // for(char i=0;i<10;i++)
    inx
    jmp __b1
}
.segment Data
  datas: .fill 2*$a, 0
