// Tests conversion of numbers to correct int types
// See https://gitlab.com/camelot/kickc/issues/181
  // Commodore 64 PRG executable file
.file [name="number-conversion.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const TYPEID_SIGNED_BYTE = 2
  .const TYPEID_SIGNED_WORD = 4
  .const TYPEID_SIGNED_DWORD = 6
  .const TYPEID_BYTE = 1
  .const TYPEID_WORD = 3
  .const TYPEID_DWORD = 5
  .const RED = 2
  .const GREEN = 5
  .label SCREEN = $400
  .label COLS = $d800
.segment Code
main: {
    // assertType(typeid(12sb+12), typeid(signed byte))
    ldx #0
    lda #TYPEID_SIGNED_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+130), typeid(signed word))
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+33000), typeid(signed dword))
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+12), typeid(signed word))
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+130), typeid(signed word))
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sw+100000), typeid(signed dword))
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+12), typeid(signed dword))
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+130), typeid(signed dword))
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sd+100000), typeid(signed dword))
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+12), typeid(unsigned byte))
    ldx #$28
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+250), typeid(unsigned byte))
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+300), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+65534), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+12), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+130), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+12), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+130), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+3000000000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-12), typeid(unsigned byte))
    ldx #$50
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-120), typeid(unsigned byte))
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-250), typeid(unsigned byte))
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-260), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-65000), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ub+-66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+-12), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+-130), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+-65000), typeid(unsigned word))
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12uw+-66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+-12), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+-130), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12ud+-66000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    // assertType(typeid(12sb+-2100000000), typeid(unsigned dword))
    lda #TYPEID_DWORD
    sta.z assertType.t2
    ldy #TYPEID_SIGNED_DWORD
    jsr assertType
    // }
    rts
}
// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
// assertType(byte register(Y) t1, byte zp(2) t2)
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
