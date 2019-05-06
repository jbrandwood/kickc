// Tests the number type used for constant expressions
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr testBytes
    jsr testSBytes
    rts
}
testSBytes: {
    // Constant values resolvable to signed bytes
    .label SCREEN = $428
    lda #-$c
    sta SCREEN
    lda #-6-6
    sta SCREEN+1
    lda #-$12+6
    sta SCREEN+2
    lda #-$714+$708
    sta SCREEN+3
    lda #-1-2-3-6
    sta SCREEN+4
    lda #-2*6
    sta SCREEN+5
    lda #-3<<2
    sta SCREEN+6
    lda #-$18>>1
    sta SCREEN+7
    lda #-4&-9
    sta SCREEN+8
    lda #-$10|-$fc
    sta SCREEN+9
    lda #(-2-2)*$f/5
    sta SCREEN+$a
    lda #$ff&$1000-$c
    sta SCREEN+$b
    rts
}
testBytes: {
    // Constant values resolvable to bytes
    .label SCREEN = $400
    lda #$c
    sta SCREEN
    lda #6+6
    sta SCREEN+1
    lda #$12-6
    sta SCREEN+2
    lda #$714-$708
    sta SCREEN+3
    lda #1+2+3+6
    sta SCREEN+4
    lda #2*6
    sta SCREEN+5
    lda #3<<2
    sta SCREEN+6
    lda #$18>>1
    sta SCREEN+7
    lda #$f&$1c
    sta SCREEN+8
    lda #4|8
    sta SCREEN+9
    lda #5^9
    sta SCREEN+$a
    lda #(2+2)*$f/5
    sta SCREEN+$b
    lda #$ff&$1000+$c
    sta SCREEN+$c
    rts
}
