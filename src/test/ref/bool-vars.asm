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
bool_and: {
    .label screen = $400
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if(o3)
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
bool_or: {
    .label screen = $428
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if(o3)
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
bool_not: {
    .label screen = $450
    ldx #0
  __b1:
    // i&1
    txa
    and #1
    // if(o3)
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
bool_complex: {
    .label screen = $478
    ldy #0
  __b1:
    // o1 = (i<10)
    cpy #$a
    lda #0
    rol
    eor #1
    tax
    // i&1
    tya
    and #1
    // o2 = (i&1)==0
    eor #0
    beq !+
    lda #1
  !:
    eor #1
    // if( o5 )
    cpx #0
    bne __b6
    jmp __b5
  __b6:
    cmp #0
    bne __b2
  __b5:
    cpx #0
    bne __b4
    cmp #0
    bne __b4
  __b2:
    // screen[i] = '*'
    lda #'*'
    sta screen,y
  __b3:
    // for( byte i : 0..20)
    iny
    cpy #$15
    bne __b1
    // }
    rts
  __b4:
    // screen[i] = ' '
    lda #' '
    sta screen,y
    jmp __b3
}
