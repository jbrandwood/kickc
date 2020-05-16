// Test implementation of kbhit() for Plus/4
.pc = $1001 "Basic"
:BasicUpstart(main)
.pc = $100d "Program"

  .const OFFSET_STRUCT_MOS7360_TED_KEYBOARD_INPUT = 8
  // Keyboard Port PIO (P0-P7)
  // The input latch is part of the TED.
  .label KEYBOARD_PORT = $fd30
  // The TED chip controlling video and sound on the Plus/4 and Commodore 16
  .label TED = $ff00
main: {
  __b1:
    // kbhit()
    jsr kbhit
    // while(!kbhit())
    cmp #0
    beq __b1
    // }
    rts
}
// Return true if there's a key waiting, return false if not
kbhit: {
    // KEYBOARD_PORT->PORT = 0x00
    // Read all keyboard matrix rows
    lda #0
    sta KEYBOARD_PORT
    // TED->KEYBOARD_INPUT = 0
    // Write to the keyboard input to latch the matrix column values
    sta TED+OFFSET_STRUCT_MOS7360_TED_KEYBOARD_INPUT
    // ~TED->KEYBOARD_INPUT
    eor #$ff
    // }
    rts
}
