.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PROCPORT = 1
  .const CHARGEN = $d000
  .const SCREEN = $400
  jsr main
main: {
    .const CHAR_A = CHARGEN+8
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
    ldx y
    lda CHAR_A,x
    sta bits
    ldx #0
  b2:
    lda bits
    and #$80
    cmp #0
    beq b3_from_b2
    lda #'*'
    jmp b3
  b3_from_b2:
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
    lda sc
    clc
    adc #$20
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
