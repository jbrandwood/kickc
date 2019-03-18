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
    sta sc
    lda #>SCREEN
    sta sc+1
    lda #0
    sta y
  b1:
    ldy y
    lda CHAR_A,y
    sta bits
    ldx #0
  b2:
    lda #$80
    and bits
    cmp #0
    beq b4
    lda #'*'
    jmp b3
  b4:
    lda #'.'
  b3:
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    asl bits
    inx
    cpx #8
    bne b2
    lda #$20
    clc
    adc sc
    sta sc
    bcc !+
    inc sc+1
  !:
    inc y
    lda y
    cmp #8
    bne b1
    lda #$37
    sta PROCPORT
    cli
    rts
}
