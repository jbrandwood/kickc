// Test array index pointer rewriting
// 8bit array with 8bit  index
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
    lda #7
    sta entities,x
    // for(char i=0;i<NUM_ENTITIES;i++)
    inx
    jmp __b1
}
  entities: .fill $19, 0
