// Test a procedure with calling convention stack
// Illustrates live ranges for printline::i and global variable val
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .label SCREEN = $400
  .label val = 2
__bbegin:
  // val = 0
  lda #0
  sta.z val
  jsr main
  rts
printline: {
    .label i = 3
    // i=0
    lda #0
    sta.z i
  __b1:
    // for(char i=0; i<40; i++)
    lda.z i
    cmp #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    ldy.z i
    sta SCREEN,y
    // for(char i=0; i<40; i++)
    inc.z i
    jmp __b1
}
main: {
    // val = '-'
    lda #'-'
    sta.z val
    // printline()
    jsr printline
    // SCREEN[80] = val
    lda.z val
    sta SCREEN+$50
    // }
    rts
}
