// Test using some simple supported string escape
// Uses \xnn to add chars by hex-code
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
.encoding "screencode_upper"
  .const CH = 'P'
  .label SCREEN1 = $400
  .label SCREEN2 = $428
  .label SCREEN3 = $428
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
    // SCREEN3[0] = CH
    lda #CH
    sta SCREEN3
    // }
    rts
  __b2:
    // SCREEN1[i] = MSG1[i]
    lda MSG1,x
    sta SCREEN1,x
    // SCREEN2[i] = MSG2[i]
    lda MSG2,x
    sta SCREEN2,x
    // i++;
    inx
    jmp __b1
}
.encoding "petscii_mixed"
  MSG1: .text "cAmElot"
  .byte 0
.encoding "screencode_upper"
  MSG2: .text "CAMELOT"
  .byte 0
