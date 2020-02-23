.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // inccnt()
    ldx #0
    jsr inccnt
    // SCREEN[0]=cnt++
    stx SCREEN
    // SCREEN[0]=cnt++;
    inx
    // inccnt()
    jsr inccnt
    // SCREEN[1]=++cnt;
    inx
    // SCREEN[1]=++cnt
    stx SCREEN+1
    // }
    rts
}
inccnt: {
    // ++cnt;
    inx
    // }
    rts
}
