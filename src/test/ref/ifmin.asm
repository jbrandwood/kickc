// Minimal if() test
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    ldx #0
  __b1:
    // if(i<50)
    cpx #$32
    bcs __b2
    // *SCREEN = i
    stx SCREEN
  __b2:
    // while(++i<100)
    inx
    cpx #$64
    bcc __b1
    // }
    rts
}
