// Test declaring a variable as register on a specific ZP address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    jsr print2
    rts
    msg: .text "hello"
    .byte 0
}
// print2(byte* zeropage($fa) at, byte* zeropage($fc) msg)
print2: {
    .label i = 2
    .label msg = $fc
    .label at = $fa
    ldx #0
    lda #<screen
    sta.z at
    lda #>screen
    sta.z at+1
    txa
    sta.z i
    lda #<main.msg
    sta.z msg
    lda #>main.msg
    sta.z msg+1
  b1:
    ldy.z i
    lda (msg),y
    cmp #0
    bne b2
    rts
  b2:
    ldy.z i
    lda (msg),y
    jsr print_char
    inx
    inx
    inc.z i
    jmp b1
}
// print_char(byte* zeropage($fa) at, byte register(X) idx, byte register(A) ch)
print_char: {
    .label at = $fa
    stx.z $ff
    ldy.z $ff
    sta (at),y
    rts
}
