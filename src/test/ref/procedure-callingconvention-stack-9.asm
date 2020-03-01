// Test a procedure with calling convention stack
// Illustrates live range problem with function variable printother::i and global variable val
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
printother: {
    .label i = 2
    // for(char i:0..5)
    lda #0
    sta.z i
  __b1:
    // (SCREEN+40)[i]++;
    ldx.z i
    inc SCREEN+$28,x
    // for(char i:0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
}
incval: {
    // val++;
    inc.z val
    // }
    rts
}
printval: {
    // SCREEN[0] = val
    lda.z val
    sta SCREEN
    // }
    rts
}
ival: {
    // incval()
    jsr incval
    // }
    rts
}
pval: {
    // printval()
    jsr printval
    // }
    rts
}
main: {
    .label i = 3
    // for(char i:0..5)
    lda #0
    sta.z i
  __b1:
    // pval()
    jsr pval
    // printother()
    jsr printother
    // ival()
    jsr ival
    // for(char i:0..5)
    inc.z i
    lda #6
    cmp.z i
    bne __b1
    // }
    rts
}
