.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  jsr main
main: {
    jsr lvalue
    jsr rvalue
    jsr rvaluevar
    jsr lvaluevar
    rts
}
lvaluevar: {
    .const b = 4
    .label screen = 2
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    ldx #2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda #b
    ldy #0
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inx
    jmp b1
}
rvaluevar: {
    ldx #2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    inx
    jmp b1
}
rvalue: {
    ldx #2
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    inx
    jmp b1
}
lvalue: {
    .label SCREEN = $400
    lda #1
    sta SCREEN
    lda #2
    sta SCREEN+1
    tax
  b1:
    cpx #$a
    bcc b2
    rts
  b2:
    lda #3
    sta SCREEN,x
    inx
    jmp b1
}