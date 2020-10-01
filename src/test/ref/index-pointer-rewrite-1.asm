// Test array index pointer rewriting
// 16bit array with 8bit index
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    ldx #0
  __b1:
    // for(char i=0;i<NUM_ENTITIES;i++)
    cpx #$19
    bcc __b2
    // }
    rts
  __b2:
    // entities[i] = 7
    txa
    asl
    tay
    lda #7
    sta entities,y
    lda #0
    sta entities+1,y
    // for(char i=0;i<NUM_ENTITIES;i++)
    inx
    jmp __b1
}
  entities: .fill 2*$19, 0
