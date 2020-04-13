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
    .label i = 2
    // *((char*)0xd018) = 0x17
    // Show mixed chars on screen
    lda #$17
    sta $d018
    lda #0
    sta.z i
  __b1:
    // while(MSG1[i])
    lda #0
    ldy.z i
    cmp MSG1,y
    bne __b2
    // SCREEN2[0] = CH
    lda #CH
    sta SCREEN2
    // }
    rts
  __b2:
    // chrout(MSG1[i])
    ldy.z i
    lda MSG1,y
    jsr chrout
    // SCREEN1[i] = MSG2[i]
    ldy.z i
    lda MSG2,y
    sta SCREEN1,y
    // i++;
    inc.z i
    jmp __b1
}
// chrout(byte register(A) petscii)
chrout: {
    .label mem = $ff
    // *mem = petscii
    sta mem
    // asm
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
