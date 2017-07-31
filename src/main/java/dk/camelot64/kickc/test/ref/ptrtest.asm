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
  sta 3
  lda #>1024
  sta 3+1
  lda #2
  sta 2
lvaluevar__B1:
  lda 2
  cmp #10
  bcc lvaluevar__B2
lvaluevar__Breturn:
  rts
lvaluevar__B2:
  ldy #0
  lda #4
  sta (3),y
  inc 3
  bne !+
  inc 3+1
!:
  inc 2
lvaluevar__B1_from_B2:
  jmp lvaluevar__B1
rvaluevar:
rvaluevar__B1_from_rvaluevar:
  lda #<1024
  sta 6
  lda #>1024
  sta 6+1
  lda #2
  sta 5
rvaluevar__B1:
  lda 5
  cmp #10
  bcc rvaluevar__B2
rvaluevar__Breturn:
  rts
rvaluevar__B2:
  ldy #0
  lda (6),y
  sta 10
  inc 6
  bne !+
  inc 6+1
!:
  inc 5
rvaluevar__B1_from_B2:
  jmp rvaluevar__B1
rvalue:
  lda 1024
  sta 11
  lda 1025
  sta 12
rvalue__B1_from_rvalue:
  lda #2
  sta 8
rvalue__B1:
  lda 8
  cmp #10
  bcc rvalue__B2
rvalue__Breturn:
  rts
rvalue__B2:
  ldx 8
  lda 1024,x
  sta 8
  inc 8
rvalue__B1_from_B2:
  jmp rvalue__B1
lvalue:
  lda #1
  sta 1024
  lda #2
  sta 1025
lvalue__B1_from_lvalue:
  lda #2
  sta 9
lvalue__B1:
  lda 9
  cmp #10
  bcc lvalue__B2
lvalue__Breturn:
  rts
lvalue__B2:
  lda #3
  ldx 9
  sta 1024,x
  inc 9
lvalue__B1_from_B2:
  jmp lvalue__B1
