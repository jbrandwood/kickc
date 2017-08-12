bbegin:
  jsr main
bend:
main: {
    jsr lvalue
  b1:
    jsr rvalue
  b2:
    jsr rvaluevar
  b3:
    jsr lvaluevar
  breturn:
    rts
}
lvaluevar: {
  b1_from_lvaluevar:
    lda #<$400
    sta $2
    lda #>$400
    sta $2+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
  breturn:
    rts
}
b2:
  ldy #$0
  lda #$4
  sta ($2),y
  inc $2
  bne !+
  inc $2+$1
!:
  inx
b1_from_b2:
  jmp b1
rvaluevar: {
  b1_from_rvaluevar:
    lda #<$400
    sta $2
    lda #>$400
    sta $2+$1
    ldx #$2
  b1:
    cpx #$a
    bcc b2
  breturn:
    rts
}
b2:
  ldy #$0
  lda ($2),y
  inc $2
  bne !+
  inc $2+$1
!:
  inx
b1_from_b2:
  jmp b1
rvalue: {
    lda $400
    lda $401
  b1_from_rvalue:
    ldx #$2
  b1:
    cpx #$a
    bcc b2
  breturn:
    rts
}
b2:
  lda $400,x
  inx
b1_from_b2:
  jmp b1
lvalue: {
    lda #$1
    sta $400
    lda #$2
    sta $401
  b1_from_lvalue:
    ldx #$2
  b1:
    cpx #$a
    bcc b2
  breturn:
    rts
}
b2:
  lda #$3
  sta $400,x
  inx
b1_from_b2:
  jmp b1
