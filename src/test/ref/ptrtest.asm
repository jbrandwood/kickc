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
    sta screen
    lda #>$400
    sta screen+1
    ldx #2
  b2:
    lda #b
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$a
    bcc b2
    rts
}
rvaluevar: {
    .label screen2 = $400
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #2
  b2:
    ldy #0
    lda (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    cpx #$a
    bcc b2
    sta screen2
    rts
}
rvalue: {
    // A constant pointer
    .label SCREEN = $400
    .label screen2 = $400
    ldx #2
  b2:
    lda SCREEN,x
    inx
    cpx #$a
    bcc b2
    sta screen2
    rts
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
  b2:
    lda #3
    sta SCREEN,x
    inx
    cpx #$a
    bcc b2
    rts
}
