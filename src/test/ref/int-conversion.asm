// Tests different integer literal types
  // Commodore 64 PRG executable file
.file [name="int-conversion.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const RED = 2
  .const GREEN = 5
  .const TYPEID_CHAR = 1
  .const TYPEID_SIGNED_CHAR = 2
  .const TYPEID_UNSIGNED_INT = 3
  .const TYPEID_INT = 4
  .const TYPEID_UNSIGNED_LONG = 5
  .const TYPEID_LONG = 6
  .label SCREEN = $400
  .label COLS = $d800
.segment Code
main: {
    .label s = 3
    lda #<SCREEN
    sta.z s
    lda #>SCREEN
    sta.z s+1
  __b1:
    // for(byte* s=SCREEN;s<SCREEN+1000;s++)
    lda.z s+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z s
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // testUnaryOperator()
    jsr testUnaryOperator
    // testBinaryOperator()
    jsr testBinaryOperator
    // }
    rts
  __b2:
    // *s = ' '
    lda #' '
    ldy #0
    sta (s),y
    // for(byte* s=SCREEN;s<SCREEN+1000;s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
testUnaryOperator: {
    // assertType(typeid(-12ub), typeid(unsigned byte))
  // Unary Operations
    ldx #0
    lda #TYPEID_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(-12sb), typeid(signed byte))
    lda #TYPEID_SIGNED_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(-12uw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(-12sw), typeid(signed word))
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(-12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(-12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // }
    rts
}
testBinaryOperator: {
    // assertType(typeid(12ub+12ub), typeid(unsigned byte))
  // Binary Operations between unsigned byte & other types
    ldx #$28
    lda #TYPEID_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12sb), typeid(unsigned byte))
    lda #TYPEID_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12uw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12sw), typeid(signed word))
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // idx++;
    inx
    // assertType(typeid(12sb+12ub), typeid(unsigned byte))
  // Binary Operations between signed byte & other types
    lda #TYPEID_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+12sb), typeid(signed byte))
    lda #TYPEID_SIGNED_CHAR
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+12uw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+12sw), typeid(signed word))
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // idx++;
    inx
    // assertType(typeid(12uw+12ub), typeid(unsigned word))
  // Binary Operations between unsigned word & other types
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12sb), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12uw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12sw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12ub), typeid(signed word))
  // Binary Operations between signed word & other types
    ldx #$50
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12sb), typeid(signed word))
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12uw), typeid(unsigned word))
    lda #TYPEID_UNSIGNED_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12sw), typeid(signed word))
    lda #TYPEID_INT
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // idx++;
    inx
    // assertType(typeid(12ud+12ub), typeid(unsigned dword))
  // Binary Operations between unsigned dword & other types
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12sb), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12uw), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12sw), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12sd), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // idx++;
    inx
    // assertType(typeid(12sd+12ub), typeid(signed dword))
  // Binary Operations between signed dword & other types
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12sb), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12uw), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12sw), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12ud), typeid(unsigned dword))
    lda #TYPEID_UNSIGNED_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12sd), typeid(signed dword))
    lda #TYPEID_LONG
    sta.z assertType.t2
    tay
    jsr assertType
    // }
    rts
}
// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
// void assertType(__register(Y) char t1, __zp(2) char t2)
assertType: {
    .label t2 = 2
    // if(t1==t2)
    tya
    cmp.z t2
    beq __b1
    // COLS[idx] = RED
    lda #RED
    sta COLS,x
  __b2:
    // SCREEN[idx++] = t1
    tya
    sta SCREEN,x
    // SCREEN[idx++] = t1;
    inx
    // }
    rts
  __b1:
    // COLS[idx] = GREEN
    lda #GREEN
    sta COLS,x
    jmp __b2
}
