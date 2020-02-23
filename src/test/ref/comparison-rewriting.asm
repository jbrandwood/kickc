// Test rewriting of constant comparisons
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    .label sc = 2
    .label screen = 4
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
  __b1:
    // *sc=' '
    lda #' '
    ldy #0
    sta (sc),y
    // for(byte* sc : SCREEN..SCREEN+1000)
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    lda.z sc+1
    cmp #>SCREEN+$3e8+1
    bne __b1
    lda.z sc
    cmp #<SCREEN+$3e8+1
    bne __b1
    ldx #0
  __b2:
    // for( byte i=0; header[i]!=0; i++)
    lda header,x
    cmp #0
    bne __b3
    lda #<SCREEN
    sta.z screen
    lda #>SCREEN
    sta.z screen+1
    ldx #0
  __b4:
    // for(byte i=0;i<=9;i++)
    cpx #9+1
    bcc __b5
    // }
    rts
  __b5:
    // screen +=40
    lda #$28
    clc
    adc.z screen
    sta.z screen
    bcc !+
    inc.z screen+1
  !:
    // '0'+i
    txa
    clc
    adc #'0'
    // screen[0] = '0'+i
    ldy #0
    sta (screen),y
    // if(i<5)
    cpx #5
    bcs __b6
    // screen[2] = '+'
    lda #'+'
    ldy #2
    sta (screen),y
  __b6:
    // if(i<=5)
    cpx #5+1
    bcs __b7
    // screen[5] = '+'
    lda #'+'
    ldy #5
    sta (screen),y
  __b7:
    // if(i==5)
    cpx #5
    bne __b8
    // screen[8] = '+'
    lda #'+'
    ldy #8
    sta (screen),y
  __b8:
    // if(i>=5)
    cpx #5
    bcc __b9
    // screen[11] = '+'
    lda #'+'
    ldy #$b
    sta (screen),y
  __b9:
    // if(i>5)
    cpx #5+1
    bcc __b10
    // screen[14] = '+'
    lda #'+'
    ldy #$e
    sta (screen),y
  __b10:
    // for(byte i=0;i<=9;i++)
    inx
    jmp __b4
  __b3:
    // SCREEN[i] = header[i]
    lda header,x
    sta SCREEN,x
    // for( byte i=0; header[i]!=0; i++)
    inx
    jmp __b2
    header: .text "  <  <= == >= >"
    .byte 0
}
