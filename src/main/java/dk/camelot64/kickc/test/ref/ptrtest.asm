  jsr main
main: {
    jsr lvalue
    jsr rvalue
    jsr rvaluevar
    jsr lvaluevar
    rts
}
lvaluevar: {
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    ldy #$0
    lda #$4
    sta (screen),y
    inc screen
    bne !+
    inc screen+$1
  !:
    inx
    jmp b1
}
rvaluevar: {
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    ldy #$0
    lda (screen),y
    inc screen
    bne !+
    inc screen+$1
  !:
    inx
    jmp b1
}
rvalue: {
    lda $400
    lda $401
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda $400,x
    inx
    jmp b1
}
lvalue: {
    lda #$1
    sta $400
    lda #$2
    sta $401
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda #$3
    sta $400,x
    inx
    jmp b1
}
