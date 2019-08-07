// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label cols = 2
    lda #<$d800
    sta.z cols
    lda #>$d800
    sta.z cols+1
  b2:
    jsr fn1
    ldy #0
    lda (cols),y
    clc
    adc #1
    sta (cols),y
    inc.z cols
    bne !+
    inc.z cols+1
  !:
    lda.z cols+1
    cmp #>$d800+$3e8
    bcc b2
    bne !+
    lda.z cols
    cmp #<$d800+$3e8
    bcc b2
  !:
    rts
}
fn1: {
    .label screen = 4
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
  b2:
    ldy #0
    lda (screen),y
    clc
    adc #1
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    lda.z screen+1
    cmp #>$400+$3e8
    bcc b2
    bne !+
    lda.z screen
    cmp #<$400+$3e8
    bcc b2
  !:
    rts
}
