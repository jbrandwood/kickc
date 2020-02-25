// Test declaring a variable as register on a specific ZP address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label i = 2
    .label j = 4
    .label __1 = 6
    .label k = 6
    // i=0
    lda #0
    sta.z i
    // j=0
    sta.z j
    sta.z j+1
  __b1:
    // while(i<4)
    lda.z i
    cmp #4
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = j++
    lda.z i
    asl
    tay
    lda.z j
    sta SCREEN,y
    lda.z j+1
    sta SCREEN+1,y
    // SCREEN[i++] = j++;
    inc.z i
    inc.z j
    bne !+
    inc.z j+1
  !:
    // (int)i
    lda.z i
    sta.z __1
    lda #0
    sta.z __1+1
    // k = (int)i*2
    asl.z k
    rol.z k+1
    // SCREEN[i++] = k
    lda.z i
    asl
    tay
    lda.z k
    sta SCREEN,y
    lda.z k+1
    sta SCREEN+1,y
    // SCREEN[i++] = k;
    inc.z i
    jmp __b1
}
