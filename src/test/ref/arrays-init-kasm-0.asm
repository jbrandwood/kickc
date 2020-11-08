// Test initializing array using KickAssembler
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    // SCREEN[0] = SINTAB[0]
    lda SINTAB
    sta SCREEN
    // }
    rts
}
// Sine table
SINTAB:
.fill 256, 128 + 128*sin(i*2*PI/256)

