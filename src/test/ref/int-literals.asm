// Tests different integer literal types
  // Commodore 64 PRG executable file
.file [name="int-literals.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const RED = 2
  .const GREEN = 5
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .const TYPEID_WORD = 3
  .const TYPEID_SIGNED_WORD = 4
  .const TYPEID_DWORD = 5
  .const TYPEID_SIGNED_DWORD = 6
  .label SCREEN = $400
  .label COLS = $d800
  .label idx = 4
.segment Code
main: {
    .label s = 2
    lda #<SCREEN
    sta.z s
    lda #>SCREEN
    sta.z s+1
  __b1:
    // for(byte* s=SCREEN;s<SCREEN+1000uw;s++)
    lda.z s+1
    cmp #>SCREEN+$3e8
    bcc __b2
    bne !+
    lda.z s
    cmp #<SCREEN+$3e8
    bcc __b2
  !:
    // testSimpleTypes()
    jsr testSimpleTypes
    // }
    rts
  __b2:
    // *s = ' '
    lda #' '
    ldy #0
    sta (s),y
    // for(byte* s=SCREEN;s<SCREEN+1000uw;s++)
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp __b1
}
testSimpleTypes: {
    // assertType(typeid(12ub), typeid(unsigned byte))
  // Simple types
    lda #0
    sta.z idx
    ldy #TYPEID_BYTE
    ldx #TYPEID_BYTE
    jsr assertType
    // assertType(typeid(12uc), typeid(unsigned byte))
    ldy #TYPEID_BYTE
    ldx #TYPEID_BYTE
    jsr assertType
    // assertType(typeid(12sb), typeid(signed byte))
    ldy #TYPEID_SIGNED_BYTE
    ldx #TYPEID_SIGNED_BYTE
    jsr assertType
    // assertType(typeid(12sc), typeid(signed byte))
    ldy #TYPEID_SIGNED_BYTE
    ldx #TYPEID_SIGNED_BYTE
    jsr assertType
    // assertType(typeid(12uw), typeid(unsigned word))
    ldy #TYPEID_WORD
    ldx #TYPEID_WORD
    jsr assertType
    // assertType(typeid(12ui), typeid(unsigned word))
    ldy #TYPEID_WORD
    ldx #TYPEID_WORD
    jsr assertType
    // assertType(typeid(12us), typeid(unsigned word))
    ldy #TYPEID_WORD
    ldx #TYPEID_WORD
    jsr assertType
    // assertType(typeid(12sw), typeid(signed word))
    ldy #TYPEID_SIGNED_WORD
    ldx #TYPEID_SIGNED_WORD
    jsr assertType
    // assertType(typeid(12si), typeid(signed word))
    ldy #TYPEID_SIGNED_WORD
    ldx #TYPEID_SIGNED_WORD
    jsr assertType
    // assertType(typeid(12ss), typeid(signed word))
    ldy #TYPEID_SIGNED_WORD
    ldx #TYPEID_SIGNED_WORD
    jsr assertType
    // assertType(typeid(12ud), typeid(unsigned dword))
    ldy #TYPEID_DWORD
    ldx #TYPEID_DWORD
    jsr assertType
    // assertType(typeid(12ul), typeid(unsigned dword))
    ldy #TYPEID_DWORD
    ldx #TYPEID_DWORD
    jsr assertType
    // assertType(typeid(12sd), typeid(signed dword))
    ldy #TYPEID_SIGNED_DWORD
    ldx #TYPEID_SIGNED_DWORD
    jsr assertType
    // assertType(typeid(12sl), typeid(signed dword))
    ldy #TYPEID_SIGNED_DWORD
    ldx #TYPEID_SIGNED_DWORD
    jsr assertType
    // assertType(typeid(12l), typeid(signed dword))
    ldy #TYPEID_SIGNED_DWORD
    ldx #TYPEID_SIGNED_DWORD
    jsr assertType
    // assertType(typeid(12u), typeid(unsigned word))
    ldy #TYPEID_WORD
    ldx #TYPEID_WORD
    jsr assertType
    // }
    rts
}
// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
// assertType(byte register(X) t1, byte register(Y) t2)
assertType: {
    // if(t1==t2)
    sty.z $ff
    cpx.z $ff
    beq __b1
    // COLS[idx] = RED
    lda #RED
    ldy.z idx
    sta COLS,y
  __b2:
    // SCREEN[idx++] = t1
    ldy.z idx
    txa
    sta SCREEN,y
    // SCREEN[idx++] = t1;
    inc.z idx
    // }
    rts
  __b1:
    // COLS[idx] = GREEN
    lda #GREEN
    ldy.z idx
    sta COLS,y
    jmp __b2
}
