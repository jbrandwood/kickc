// Test loop invariant computation detection
// http://www.cs.toronto.edu/~pekhimenko/courses/cscd70-w18/docs/Lecture%205%20[LICM%20and%20Strength%20Reduction]%2002.08.2018.pdf
// In a double loop a constant expression in the inner loop is hoisted out into the outer loop
// SCREEN + (unsigned int)y*40 can be hoisted to the outer y-loop
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __2 = 2
    .label __3 = 2
    .label __5 = 2
    .label __6 = 4
    .label __7 = 2
    ldx #0
  __b1:
    // for(char y=0;y<25;y++)
    cpx #$19
    bcc __b2
    // }
    rts
  __b2:
    // (unsigned int)y*40
    txa
    sta.z __5
    lda #0
    sta.z __5+1
    lda.z __5
    asl
    sta.z __6
    lda.z __5+1
    rol
    sta.z __6+1
    asl.z __6
    rol.z __6+1
    lda.z __7
    clc
    adc.z __6
    sta.z __7
    lda.z __7+1
    adc.z __6+1
    sta.z __7+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    asl.z __2
    rol.z __2+1
    // SCREEN + (unsigned int)y*40
    clc
    lda.z __3
    adc #<SCREEN
    sta.z __3
    lda.z __3+1
    adc #>SCREEN
    sta.z __3+1
    ldy #0
  __b3:
    // for(char x=0;x<40;x++)
    cpy #$28
    bcc __b4
    // for(char y=0;y<25;y++)
    inx
    jmp __b1
  __b4:
    // *p = '*'
    lda #'*'
    sta (__3),y
    // for(char x=0;x<40;x++)
    iny
    jmp __b3
}
