.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label SCREEN = $400
    ldx #0
  __b1:
    // for( unsigned char i = 0; i<128; i+=2)
    cpx #$80
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = 'a'
    lda #'a'
    sta SCREEN,x
    // (*(unsigned char*)0xD020)=0
    lda #0
    sta $d020
    // i+=2
    inx
    inx
    jmp __b1
}
