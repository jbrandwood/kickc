.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    .label offset = $28*$a
    ldx #0
  __b1:
    // for (char x=0;x<254;x++)
    cpx #$fe
    bcc __b2
    // }
    rts
  __b2:
    // incscreen(offset)
    jsr incscreen
    // for (char x=0;x<254;x++)
    inx
    jmp __b1
}
incscreen: {
    // --(*(screen+ptr));
    dec screen+main.offset
    // (*(screen+ptr+1))--;
    dec screen+main.offset+1
    // ++(*(screen+ptr));
    inc screen+main.offset
    // (*(screen+ptr+1))++;
    inc screen+main.offset+1
    // }
    rts
}
