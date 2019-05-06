// Tests conversion of numbers to correct int types
// See https://gitlab.com/camelot/kickc/issues/181
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const TYPEID_SIGNED_BYTE = 2
  .const TYPEID_SIGNED_WORD = 4
  .const TYPEID_SIGNED_DWORD = 6
  .const TYPEID_BYTE = 1
  .const TYPEID_WORD = 3
  .const TYPEID_DWORD = 5
  .const RED = 2
  .const GREEN = 5
main: {
    ldx #0
    lda #TYPEID_SIGNED_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta assertType.t2
    tay
    jsr assertType
    ldx #$28
    lda #TYPEID_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    ldx #$50
    lda #TYPEID_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_BYTE
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_WORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
    sta assertType.t2
    ldy #TYPEID_SIGNED_DWORD
    jsr assertType
    rts
}
// Check that the two passed type IDs are equal.
// Shows a letter symbolizing t1
// If they are equal the letter is green - if not it is red.
// assertType(byte register(Y) t1, byte zeropage(2) t2)
assertType: {
    .label t2 = 2
    tya
    cmp t2
    beq b1
    lda #RED
    sta $d800,x
  b2:
    tya
    sta $400,x
    inx
    rts
  b1:
    lda #GREEN
    sta $d800,x
    jmp b2
}
