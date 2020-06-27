// Test a procedure with calling convention stack
// Illustrates live ranges for main::val and printline::i
.pc = $801 "Basic"
:BasicUpstart(__start)
.pc = $80d "Program"
  .label SCREEN = $400
__start: {
    jsr main
    rts
}
printline: {
    ldx #0
  __b1:
    // for(char i=0; i<40; i++)
    cpx #$28
    bcc __b2
    // }
    rts
  __b2:
    // SCREEN[i] = '*'
    lda #'*'
    sta SCREEN,x
    // for(char i=0; i<40; i++)
    inx
    jmp __b1
}
main: {
    // val = *SCREEN
    ldy SCREEN
    // printline()
    jsr printline
    // SCREEN[80] = val
    sty SCREEN+$50
    // }
    rts
}
