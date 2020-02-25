// Test auto-casting of call-parameters
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
main: {
    .const w = $1234
    // print(0x1234)
    lda #<$1234
    sta.z print.w
    lda #>$1234
    sta.z print.w+1
    ldx #0
    jsr print
    // print(w)
    lda #<w
    sta.z print.w
    lda #>w
    sta.z print.w+1
    jsr print
    // print( {0x12,0x34} )
    lda #<$12*$100+$34
    sta.z print.w
    lda #>$12*$100+$34
    sta.z print.w+1
    jsr print
    // }
    rts
}
// print(word zp(2) w)
print: {
    .label w = 2
    // SCREEN[idx++] = w
    txa
    asl
    tay
    lda.z w
    sta SCREEN,y
    lda.z w+1
    sta SCREEN+1,y
    // SCREEN[idx++] = w;
    inx
    // }
    rts
}
