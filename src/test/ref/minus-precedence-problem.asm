.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const matrixSize = 8
  .const matrixSizeMask = $ff-(matrixSize-1)
main: {
    // *((unsigned char *)0x400) = matrixSizeMask
    lda #matrixSizeMask
    sta $400
    // }
    rts
}
