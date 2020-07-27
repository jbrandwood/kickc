// Demonstrates Wrong allocation of arrays.
// https://gitlab.com/camelot/kickc/-/issues/497
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_POINTER = 2
main: {
    ldx #0
  __b1:
    // for(char c=0;c<sizeof(levelRowOff)/sizeof(char*); c++)
    cpx #$1f*SIZEOF_POINTER/SIZEOF_POINTER
    bcc __b2
    // }
    rts
  __b2:
    // levelRowOff[c] = 12345
    txa
    asl
    tay
    lda #<$3039
    sta levelRowOff,y
    lda #>$3039
    sta levelRowOff+1,y
    // for(char c=0;c<sizeof(levelRowOff)/sizeof(char*); c++)
    inx
    jmp __b1
}
  levelRowOff: .word 1, 2, 3
  .fill 2*$1c, 0
