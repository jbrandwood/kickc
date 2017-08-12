  jsr main
main: {
    jsr lvalue
    jsr rvalue
    jsr rvaluevar
    jsr lvaluevar
    rts
}
lvaluevar: {
    lda #<$400
    sta $2
    lda #>$400
    sta $2+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    ldy #$0
    lda #$4
    sta ($2),y
    inc $2
    bne !+
    inc $2+$1
  !:
    inx
    jmp b1
}
rvaluevar: {
    lda #<$400
    sta $2
    lda #>$400
    sta $2+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    ldy #$0
    lda ($2),y
    inc $2
    bne !+
    inc $2+$1
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
