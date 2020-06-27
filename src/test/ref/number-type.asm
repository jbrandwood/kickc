// Tests the number type used for constant expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    // testBytes()
    jsr testBytes
    // testSBytes()
    jsr testSBytes
    // }
    rts
}
testBytes: {
    // Constant values resolvable to bytes
    .label SCREEN = $400
    // SCREEN[idx++] = 12
    lda #$c
    sta SCREEN
    // SCREEN[idx++] = 6+6
    lda #6+6
    sta SCREEN+1
    // SCREEN[idx++] = 18-6
    lda #$12-6
    sta SCREEN+2
    // SCREEN[idx++] = 1812-1800
    lda #$714-$708
    sta SCREEN+3
    // SCREEN[idx++] = 1+2+3+6
    lda #1+2+3+6
    sta SCREEN+4
    // SCREEN[idx++] = 2*6
    lda #2*6
    sta SCREEN+5
    // SCREEN[idx++] = 3<<2
    lda #3<<2
    sta SCREEN+6
    // SCREEN[idx++] = 24>>1
    lda #$18>>1
    sta SCREEN+7
    // SCREEN[idx++] = 15&28
    lda #$f&$1c
    sta SCREEN+8
    // SCREEN[idx++] = 4|8
    lda #4|8
    sta SCREEN+9
    // SCREEN[idx++] = 5^9
    lda #5^9
    sta SCREEN+$a
    // SCREEN[idx++] = (2+2)*(15/5)
    lda #(2+2)*$f/5
    sta SCREEN+$b
    // SCREEN[idx++] = (byte)(4096+12)
    lda #$ff&$1000+$c
    sta SCREEN+$c
    // }
    rts
}
testSBytes: {
    // Constant values resolvable to signed bytes
    .label SCREEN = $428
    // SCREEN[idx++] = -12
    lda #-$c
    sta SCREEN
    // SCREEN[idx++] = -6-6
    lda #-6-6
    sta SCREEN+1
    // SCREEN[idx++] = -18+6
    lda #-$12+6
    sta SCREEN+2
    // SCREEN[idx++] = -1812+1800
    lda #-$714+$708
    sta SCREEN+3
    // SCREEN[idx++] = -1-2-3-6
    lda #-1-2-3-6
    sta SCREEN+4
    // SCREEN[idx++] = -2*6
    lda #-2*6
    sta SCREEN+5
    // SCREEN[idx++] = -3<<2
    lda #-3<<2
    sta SCREEN+6
    // SCREEN[idx++] = -24>>1
    lda #-$18>>1
    sta SCREEN+7
    // SCREEN[idx++] = -4&-9
    lda #-4&-9
    sta SCREEN+8
    // SCREEN[idx++] = -0x10|-0xfc
    lda #-$10|-$fc
    sta SCREEN+9
    // SCREEN[idx++] = (-2-2)*(15/5)
    lda #(-2-2)*$f/5
    sta SCREEN+$a
    // SCREEN[idx++] = (signed byte)(4096-12)
    lda #$ff&$1000-$c
    sta SCREEN+$b
    // }
    rts
}
