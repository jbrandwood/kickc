// Tests different integer literal types
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const TYPEID_BYTE = 1
  .const TYPEID_SIGNED_BYTE = 2
  .const TYPEID_WORD = 3
  .const TYPEID_SIGNED_WORD = 4
  .const TYPEID_DWORD = 5
  .const TYPEID_SIGNED_DWORD = 6
  .const RED = 2
  .const GREEN = 5
  .label SCREEN = $400
  .label COLS = $d800
main: {
    .label s = 2
    lda #<SCREEN
    sta.z s
    lda #>SCREEN
    sta.z s+1
  b1:
    lda.z s+1
    cmp #>SCREEN+$3e8
    bcc b2
    bne !+
    lda.z s
    cmp #<SCREEN+$3e8
    bcc b2
  !:
    jsr testUnaryOperator
    jsr testBinaryOperator
    rts
  b2:
    lda #' '
    ldy #0
    sta (s),y
    inc.z s
    bne !+
    inc.z s+1
  !:
    jmp b1
}
testBinaryOperator: {
    ldx #$28
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    inx
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    inx
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    ldx #$50
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    inx
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    inx
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    rts
}
// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
// assertType(byte register(Y) t1, byte zeropage(4) t2)
assertType: {
    .label t2 = 4
    tya
    cmp.z t2
    beq b1
    lda #RED
    sta COLS,x
  b2:
    tya
    sta SCREEN,x
    inx
    rts
  b1:
    lda #GREEN
    sta COLS,x
    jmp b2
}
testUnaryOperator: {
    ldx #0
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    rts
}
