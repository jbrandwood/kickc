.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label PROCPORT = 1
  .label CHARGEN = $d000
  .label SCREEN = $400
main: {
    .label CHAR_A = CHARGEN+8
    .label bits = 3
    .label sc = 4
    .label y = 2
    // asm
    sei
    // *PROCPORT = $32
    lda #$32
    sta PROCPORT
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
    lda #0
    sta.z y
  __b1:
    // bits = CHAR_A[y]
    ldy.z y
    lda CHAR_A,y
    sta.z bits
    ldx #0
  __b2:
    // bits & $80
    lda #$80
    and.z bits
    // if((bits & $80) != 0)
    cmp #0
    beq b1
    lda #'*'
    jmp __b3
  b1:
    lda #'.'
  __b3:
    // *sc = c
    ldy #0
    sta (sc),y
    // sc++;
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    // bits = bits*2
    asl.z bits
    // for(byte x:0..7)
    inx
    cpx #8
    bne __b2
    // sc = sc+32
    lda #$20
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    // for(byte y:0..7)
    inc.z y
    lda #8
    cmp.z y
    bne __b1
    // *PROCPORT = $37
    lda #$37
    sta PROCPORT
    // asm
    cli
    // }
    rts
}
