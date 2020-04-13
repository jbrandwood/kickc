// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
.encoding "screencode_upper"
  .const CH = '\$de'
  .label SCREEN1 = $400
  .label SCREEN2 = $428
main: {
    // *((char*)0xd018) = 0x17
    // Show mixed chars on screen
    lda #$17
    sta $d018
    ldx #0
  __b1:
    // while(MSG1[i])
    lda MSG1,x
    cmp #0
    bne __b2
    // SCREEN2[0] = CH
    lda #CH
    sta SCREEN2
    // }
    rts
  __b2:
    // chrout(MSG1[i])
    lda MSG1,x
    jsr chrout
    // SCREEN1[i] = MSG2[i]
    lda MSG2,x
    sta SCREEN1,x
    // i++;
    inx
    jmp __b1
}
// chrout(byte register(A) petscii)
chrout: {
    // kickasm
    jsr $ffd2
    
    // }
    rts
}
.encoding "petscii_mixed"
  MSG1: .text "cAmElot"
  .byte 0
.encoding "screencode_upper"
  MSG2: .text "CAMELOT"
  .byte 0
