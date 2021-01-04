// Test array index pointer rewriting
// struct array with 8bit index
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-8.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const OFFSET_STRUCT_BALL_VEL = 1
  .const OFFSET_STRUCT_BALL_SYM = 2
.segment Code
main: {
    ldy #0
  __b1:
    // for(char i=0;i<NUM_BALLS;i++)
    cpy #$19
    bcc __b2
    // }
    rts
  __b2:
    // balls[i].pos += balls[i].vel
    tya
    asl
    sty.z $ff
    clc
    adc.z $ff
    tax
    lda balls,x
    clc
    adc balls+OFFSET_STRUCT_BALL_VEL,x
    sta balls,x
    // balls[i].vel += 10
    lda #$a
    clc
    adc balls+OFFSET_STRUCT_BALL_VEL,x
    sta balls+OFFSET_STRUCT_BALL_VEL,x
    // balls[i].sym ='*'
    lda #'*'
    sta balls+OFFSET_STRUCT_BALL_SYM,x
    // for(char i=0;i<NUM_BALLS;i++)
    iny
    jmp __b1
}
.segment Data
  balls: .fill 3*$19, 0
