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
    sei
    lda #$32
    sta PROCPORT
    lda #<SCREEN
    sta.z sc
    lda #>SCREEN
    sta.z sc+1
    lda #0
    sta.z y
  b1:
    ldy.z y
    lda CHAR_A,y
    sta.z bits
    ldx #0
  b2:
    lda #$80
    and.z bits
    cmp #0
    beq b4
    lda #'*'
    jmp b3
  b4:
    lda #'.'
  b3:
    ldy #0
    sta (sc),y
    inc.z sc
    bne !+
    inc.z sc+1
  !:
    asl.z bits
    inx
    cpx #8
    bne b2
    lda #$20
    clc
    adc.z sc
    sta.z sc
    bcc !+
    inc.z sc+1
  !:
    inc.z y
    lda #8
    cmp.z y
    bne b1
    lda #$37
    sta PROCPORT
    cli
    rts
}
