// Test declaring a variable as register on a specific ZP address
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label screen = $400
main: {
    // print2(screen, "hello")
    lda #<screen
    sta.z print2.at
    lda #>screen
    sta.z print2.at+1
    lda #<msg
    sta.z print2.msg
    lda #>msg
    sta.z print2.msg+1
    jsr print2
    // print2(screen+80, "world")
    lda #<screen+$50
    sta.z print2.at
    lda #>screen+$50
    sta.z print2.at+1
    lda #<msg1
    sta.z print2.msg
    lda #>msg1
    sta.z print2.msg+1
    jsr print2
    // }
    rts
    msg: .text "hello"
    .byte 0
    msg1: .text "world"
    .byte 0
}
// print2(byte* zp($fa) at, byte* zp($fc) msg)
print2: {
    .label at = $fa
    .label msg = $fc
    .label i = 2
    ldx #0
    txa
    sta.z i
  __b1:
    // for(byte i=0; msg[i]; i++)
    ldy.z i
    lda (msg),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(at, j, msg[i])
    ldy.z i
    lda (msg),y
    jsr print_char
    // j += 2
    inx
    inx
    // for(byte i=0; msg[i]; i++)
    inc.z i
    jmp __b1
}
// print_char(byte* zp($fa) at, byte register(X) idx, byte register(A) ch)
print_char: {
    .label at = $fa
    // at[idx] = ch
    stx.z $ff
    ldy.z $ff
    sta (at),y
    // }
    rts
}
