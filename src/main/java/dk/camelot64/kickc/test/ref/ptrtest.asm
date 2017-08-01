BBEGIN:
  jsr main
BEND:
main:
  jsr lvalue
main__B1:
  jsr rvalue
main__B2:
  jsr rvaluevar
main__B3:
  jsr lvaluevar
main__Breturn:
  rts
lvaluevar:
lvaluevar__B1_from_lvaluevar:
  lda #<1024
  sta 2
  lda #>1024
  sta 2+1
  ldx #2
lvaluevar__B1:
  cpx #10
  bcc lvaluevar__B2
lvaluevar__Breturn:
  rts
lvaluevar__B2:
  ldy #0
  lda #4
  sta (2),y
  inc 2
  bne !+
  inc 2+1
!:
  inx
lvaluevar__B1_from_B2:
  jmp lvaluevar__B1
rvaluevar:
rvaluevar__B1_from_rvaluevar:
  lda #<1024
  sta 2
  lda #>1024
  sta 2+1
  ldx #2
rvaluevar__B1:
  cpx #10
  bcc rvaluevar__B2
rvaluevar__Breturn:
  rts
rvaluevar__B2:
  ldy #0
  lda (2),y
  inc 2
  bne !+
  inc 2+1
!:
  inx
rvaluevar__B1_from_B2:
  jmp rvaluevar__B1
rvalue:
  lda 1024
  lda 1025
rvalue__B1_from_rvalue:
  ldx #2
rvalue__B1:
  cpx #10
  bcc rvalue__B2
rvalue__Breturn:
  rts
rvalue__B2:
  lda 1024,x
  inx
rvalue__B1_from_B2:
  jmp rvalue__B1
lvalue:
  lda #1
  sta 1024
  lda #2
  sta 1025
lvalue__B1_from_lvalue:
  ldx #2
lvalue__B1:
  cpx #10
  bcc lvalue__B2
lvalue__Breturn:
  rts
lvalue__B2:
  lda #3
  sta 1024,x
  inx
lvalue__B1_from_B2:
  jmp lvalue__B1
