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
  .label SCREEN = $400
  .label COLS = $d800
main: {
    ldx #0
    lda #TYPEID_SIGNED_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_SIGNED_WORD
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
    lda #TYPEID_SIGNED_DWORD
    sta.z assertType.t2
    tay
    jsr assertType
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
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
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
    ldx #$50
    lda #TYPEID_BYTE
    sta.z assertType.t2
    tay
    jsr assertType
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
    lda #TYPEID_WORD
    sta.z assertType.t2
    tay
    jsr assertType
    lda #TYPEID_DWORD
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
