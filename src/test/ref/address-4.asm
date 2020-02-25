// Test declaring a variable as at a hard-coded address
// Incrementing a load/store variable will result in cause two *SIZEOF's
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const ch = $102
    .label i = 2
    // i=0
    lda #0
    sta.z i
  __b1:
    // while(i<8)
    lda.z i
    cmp #8
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i++] = ch
    lda.z i
    asl
    tay
    lda #<ch
    sta SCREEN,y
    lda #>ch
    sta SCREEN+1,y
    // SCREEN[i++] = ch;
    inc.z i
    // SCREEN[i++] = ch
    lda.z i
    asl
    tay
    lda #<ch
    sta SCREEN,y
    lda #>ch
    sta SCREEN+1,y
    // SCREEN[i++] = ch;
    inc.z i
    jmp __b1
}
