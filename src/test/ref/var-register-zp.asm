// Test declaring a variable as register on a specific ZP address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __1 = 6
    .label i = 2
    .label j = 4
    .label k = 6
    lda #<0
    sta.z j
    sta.z j+1
    sta.z i
  __b1:
    lda.z i
    cmp #4
    bcc __b2
    rts
  __b2:
    lda.z i
    asl
    tay
    lda.z j
    sta SCREEN,y
    lda.z j+1
    sta SCREEN+1,y
    inc.z i
    inc.z j
    bne !+
    inc.z j+1
  !:
    lda.z i
    sta.z __1
    lda #0
    sta.z __1+1
    asl.z k
    rol.z k+1
    lda.z i
    asl
    tay
    lda.z k
    sta SCREEN,y
    lda.z k+1
    sta SCREEN+1,y
    inc.z i
    jmp __b1
}
