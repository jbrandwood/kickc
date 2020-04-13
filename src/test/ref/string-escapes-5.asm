// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code that do not exist with the encoding.
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const CH = '\$ff'
main: {
    ldx #0
  __b1:
    // while(MESSAGE[i])
    lda MESSAGE,x
    cmp #0
    bne __b2
    // SCREEN[0x28] = CH
    lda #CH
    sta SCREEN+$28
    // }
    rts
  __b2:
    // SCREEN[i] = MESSAGE[i++]
    lda MESSAGE,x
    sta SCREEN,x
    // SCREEN[i] = MESSAGE[i++];
    inx
    jmp __b1
}
  MESSAGE: .text @"q\$ffw\$60e\$ddr"
  .byte 0
