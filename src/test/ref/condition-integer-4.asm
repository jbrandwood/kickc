// Tests using integer conditions in && and || operator
// This should produce '01010101', '00110011', '00010001', '01110111' at the top of the screen
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __4 = 2
    .label __5 = 3
    ldy #0
    ldx #0
  __b1:
    // i&1
    lda #1
    sax.z __4
    // if(i&1)
    lda #0
    cmp.z __4
    beq __b2
    // (SCREEN+40*0)[idx] = '+'
    lda #'+'
    sta SCREEN,y
  __b2:
    // i&2
    lda #2
    sax.z __5
    // if(i&2)
    lda #0
    cmp.z __5
    beq __b3
    // (SCREEN+40*1)[idx] = '+'
    lda #'+'
    sta SCREEN+$28*1,y
  __b3:
    // if(i&1 && i&2)
    lda #0
    cmp.z __4
    beq __b4
    cmp.z __5
    beq __b4
    // (SCREEN+40*2)[idx] = '+'
    lda #'+'
    sta SCREEN+$28*2,y
  __b4:
    // if(i&1 || i&2)
    lda #0
    cmp.z __4
    bne __b9
    cmp.z __5
    beq __b5
  __b9:
    // (SCREEN+40*3)[idx] = '+'
    lda #'+'
    sta SCREEN+$28*3,y
  __b5:
    // idx++;
    iny
    // for( byte i:0..7)
    inx
    cpx #8
    bne __b1
    // }
    rts
}
