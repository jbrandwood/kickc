// Test ATARI chipset variations
// Pointer to struct versus MAcro pointer to struct
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PIA2 = $d300
main: {
    // PIA1.porta = 7
    lda #7
    sta $d300
    // PIA2->PORTA = 7
    sta PIA2
    // }
    rts
}
