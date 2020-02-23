// Tests that inline asm uses clause makes the compiler not cull a procedure referenced
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BGCOL = $d020
main: {
    // asm
    jsr init
    // }
    rts
}
// Function only used inside the inline asm
init: {
    // *BGCOL = 0
    lda #0
    sta BGCOL
    // }
    rts
}
