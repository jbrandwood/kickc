// Test array index pointer rewriting
// struct array with 16bit index
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const OFFSET_STRUCT_BALL_VEL = 1
  .const OFFSET_STRUCT_BALL_SYM = 2
main: {
    .label __2 = 4
    .label i = 2
    .label __4 = 6
    .label __5 = 8
    .label __6 = $a
    .label __7 = $c
    .label __8 = $e
    .label __9 = 4
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
    lda.z __2
    clc
    adc #<balls
    sta.z __4
    lda.z __2+1
    adc #>balls
    sta.z __4+1
    lda.z __2
    clc
    adc #<balls+OFFSET_STRUCT_BALL_VEL
    sta.z __5
    lda.z __2+1
    adc #>balls+OFFSET_STRUCT_BALL_VEL
    sta.z __5+1
    lda.z __2
    clc
    adc #<balls
    sta.z __6
    lda.z __2+1
    adc #>balls
    sta.z __6+1
    ldy #0
    lda (__4),y
    clc
    adc (__5),y
    sta (__6),y
    // balls[i].vel += 10
    lda.z __2
    clc
    adc #<balls+OFFSET_STRUCT_BALL_VEL
    sta.z __7
    lda.z __2+1
    adc #>balls+OFFSET_STRUCT_BALL_VEL
    sta.z __7+1
    lda.z __2
    clc
    adc #<balls+OFFSET_STRUCT_BALL_VEL
    sta.z __8
    lda.z __2+1
    adc #>balls+OFFSET_STRUCT_BALL_VEL
    sta.z __8+1
    lda #$a
    clc
    adc (__7),y
    sta (__8),y
    // balls[i].sym ='*'
    clc
    lda.z __9
    adc #<balls+OFFSET_STRUCT_BALL_SYM
    sta.z __9
    lda.z __9+1
    adc #>balls+OFFSET_STRUCT_BALL_SYM
    sta.z __9+1
    lda #'*'
    sta (__9),y
    // for(unsigned short i=0;i<NUM_BALLS;i++)
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
  balls: .fill 3*$19, 0
