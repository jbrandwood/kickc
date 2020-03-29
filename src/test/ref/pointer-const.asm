// Test pointer to const and const pointer
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // Const pointer
  .label SCREEN = $400
  // Const pointer to const
  .label BASIC = $a004
main: {
    ldx #0
  __b1:
    // while(MSG[i])
    lda MSG,x
    cmp #0
    bne __b2
    ldx #0
  __b3:
    // while(BASIC[i]!='0')
    lda BASIC,x
    cmp #'0'
    bne __b4
    // }
    rts
  __b4:
    // BASIC[i]&0x3f
    lda #$3f
    and BASIC,x
    // SCREEN[40+i] = BASIC[i]&0x3f
    sta SCREEN+$28,x
    // i++;
    inx
    jmp __b3
  __b2:
    // SCREEN[i] = MSG[i]
    lda MSG,x
    sta SCREEN,x
    // i++;
    inx
    jmp __b1
}
  // Pointer to const
  MSG: .text "hello world!"
  .byte 0
