// Test all types of pointers
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr lvalue
    jsr rvalue
    jsr rvaluevar
    jsr lvaluevar
    rts
}
lvaluevar: {
    // LValue Variable pointer dereference
    .const b = 4
    .label screen = 2
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #2
  __b1:
    cpx #$a
    bcc __b2
    rts
  __b2:
    lda #b
    ldy #0
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    jmp __b1
}
rvaluevar: {
    .label screen2 = $400
    .label screen = 2
    ldy #0
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    ldx #2
  __b1:
    cpx #$a
    bcc __b2
    sty screen2
    rts
  __b2:
    ldy #0
    lda (screen),y
    tay
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inx
    jmp __b1
}
rvalue: {
    // A constant pointer
    .label SCREEN = $400
    .label screen2 = $400
    // RValue constant array pointer constant index
    lda SCREEN+1
    ldx #2
  __b1:
    cpx #$a
    bcc __b2
    sta screen2
    rts
  __b2:
    lda SCREEN,x
    inx
    jmp __b1
}
lvalue: {
    // A constant pointer
    .label SCREEN = $400
    // LValue constant pointer dereference
    lda #1
    sta SCREEN
    // LValue constant array constant indexing
    lda #2
    sta SCREEN+1
    tax
  __b1:
    cpx #$a
    bcc __b2
    rts
  __b2:
    lda #3
    sta SCREEN,x
    inx
    jmp __b1
}
