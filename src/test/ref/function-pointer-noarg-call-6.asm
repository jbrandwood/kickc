// Tests calling into a function pointer with local variables
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    .label cls = fn1
    .label cols = 2
    lda #<$d800
    sta cols
    lda #>$d800
    sta cols+1
  b1:
    jsr cls
    inc cols
    bne !+
    inc cols+1
  !:
    inc cols
    bne !+
    inc cols+1
  !:
    lda cols+1
    cmp #>$d800+$3e8
    bcc b1
    bne !+
    lda cols
    cmp #<$d800+$3e8
    bcc b1
  !:
    rts
}
fn1: {
    .label screen = 4
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
  b1:
    ldy #0
    lda (screen),y
    clc
    adc #1
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    lda screen+1
    cmp #>$400+$3e8
    bcc b1
    bne !+
    lda screen
    cmp #<$400+$3e8
    bcc b1
  !:
    rts
}
