// Tests that inline asm uses clause makes the compiler not cull a procedure referenced
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label BG_COLOR = $d020
// Function only used inside the inline asm
init: {
    // *BG_COLOR = 0
    lda #0
    sta BG_COLOR
    // }
    rts
}
main: {
    // asm
    jsr init
    // }
    rts
}
