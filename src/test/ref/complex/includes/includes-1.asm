// Includes a system library - ignores the local file with the same name
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .label __0 = 4
    // strlen(STR)
    jsr strlen
    // strlen(STR)
    // (char) strlen(STR)
    lda.z __0
    // SCREEN [0] = (char) strlen(STR)
    sta SCREEN
    // }
    rts
}
// Computes the length of the string str up to but not including the terminating null character.
// strlen(byte* zp(2) str)
strlen: {
    .label len = 4
    .label str = 2
    .label return = 4
    lda #<0
    sta.z len
    sta.z len+1
    lda #<STR
    sta.z str
    lda #>STR
    sta.z str+1
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // len++;
    inc.z len
    bne !+
    inc.z len+1
  !:
    // str++;
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
  STR: .text "camelot!"
  .byte 0
