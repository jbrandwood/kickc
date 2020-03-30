// A test of boolean conditions using && || and !
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // bool_and()
    jsr bool_and
    // bool_or()
    jsr bool_or
    // bool_not()
    jsr bool_not
    // bool_complex()
    jsr bool_complex
    // }
    rts
}
bool_complex: {
    .label screen = $478
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( ((i<10) && (i&1)==0) || !((i<10) || (i&1)==0) )
    cpx #$a
    bcs __b5
    cmp #0
    beq __b2
  __b5:
    cpx #$a
    bcc __b4
    cmp #0
    beq __b4
  __b2:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
  __b3:
    // for( byte i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
  __b4:
    // screen[i] = ' '
    lda #' '
    sta screen,x
    jmp __b3
}
bool_not: {
    .label screen = $450
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( !((i<10) || (i&1)==0))
    cpx #$a
    bcc __b4
    cmp #0
    beq __b4
    // screen[i] = '*'
    lda #'*'
    sta screen,x
  __b3:
    // for( byte i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
  __b4:
    // screen[i] = ' '
    lda #' '
    sta screen,x
    jmp __b3
}
bool_or: {
    .label screen = $428
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( (i<10) || ((i&1)==0) )
    cpx #$a
    bcc __b2
    cmp #0
    beq __b2
    // screen[i] = ' '
    lda #' '
    sta screen,x
  __b3:
    // for( byte i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
  __b2:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
    jmp __b3
}
bool_and: {
    .label screen = $400
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if( (i<10) && ((i&1)==0) )
    cpx #$a
    bcs __b4
    cmp #0
    beq __b2
  __b4:
    // screen[i] = ' '
    lda #' '
    sta screen,x
  __b3:
    // for( byte i : 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
  __b2:
    // screen[i] = '*'
    lda #'*'
    sta screen,x
    jmp __b3
}
