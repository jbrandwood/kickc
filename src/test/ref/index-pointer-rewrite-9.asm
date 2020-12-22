// Test array index pointer rewriting
// struct array with 16bit index
  // Commodore 64 PRG executable file
.file [name="index-pointer-rewrite-9.prg", type="prg", segments="Program"]
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
    .label __2 = 4
    .label __8 = 4
    .label i = 2
    .label __10 = 4
    lda #<0
    sta.z i
    sta.z i+1
  __b1:
    // for(unsigned short i=0;i<NUM_BALLS;i++)
    lda.z i+1
    bne !+
    lda.z i
    cmp #$19
    bcc __b2
  !:
    // }
    rts
  __b2:
    // balls[i].pos += balls[i].vel
    lda.z i
    asl
    sta.z __10
    lda.z i+1
    rol
    sta.z __10+1
    lda.z __2
    clc
    adc.z i
    sta.z __2
    lda.z __2+1
    adc.z i+1
    sta.z __2+1
    clc
    lda.z __8
    adc #<balls
    sta.z __8
    lda.z __8+1
    adc #>balls
    sta.z __8+1
    ldy #0
    lda (__8),y
    ldy #OFFSET_STRUCT_BALL_VEL
    clc
    adc (__8),y
    ldy #0
    sta (__8),y
    // balls[i].vel += 10
    lda #$a
    ldy #OFFSET_STRUCT_BALL_VEL
    clc
    adc (__8),y
    sta (__8),y
    // balls[i].sym ='*'
    lda #'*'
    ldy #OFFSET_STRUCT_BALL_SYM
    sta (__8),y
    // for(unsigned short i=0;i<NUM_BALLS;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
.segment Data
  balls: .fill 3*$19, 0
