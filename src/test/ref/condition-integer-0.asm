// Tests using integer conditions in if()
// This should produce '+ ++ ++' at the top of the screen
  // Commodore 64 PRG executable file
.file [name="condition-integer-0.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label SCREEN = $400
.segment Code
main: {
    .label i1 = 2
    // SCREEN[idx++] = '+'
    lda #'+'
    sta SCREEN
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN+1
    ldy #2
    ldx #0
  // loop byte
  __b3:
    // if(i)
    cpx #0
    beq __b4
    // SCREEN[idx++] = '+'
    lda #'+'
    sta SCREEN,y
    // SCREEN[idx++] = '+';
    iny
  __b4:
    // for( byte i:0..2)
    inx
    cpx #3
    bne __b3
    // SCREEN[idx++] = ' '
    lda #' '
    sta SCREEN,y
    // SCREEN[idx++] = ' ';
    iny
    lda #<0
    sta.z i1
    sta.z i1+1
  // loop word
  __b7:
    // if(i)
    lda.z i1
    ora.z i1+1
    beq __b8
    // SCREEN[idx++] = '+'
    lda #'+'
    sta SCREEN,y
    // SCREEN[idx++] = '+';
    iny
  __b8:
    // for( word i:0..2)
    inc.z i1
    bne !+
    inc.z i1+1
  !:
    lda.z i1+1
    bne __b7
    lda.z i1
    cmp #3
    bne __b7
    // }
    rts
}
