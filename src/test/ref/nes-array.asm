// Test a bit of array code from the NES forum
// https://forums.nesdev.com/viewtopic.php?f=2&t=18735
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .label SCREEN = $400
    .label __1 = 2
    .label __3 = 2
    .label y1 = 4
    .label y2 = 6
    lda #<$1234
    sta.z y1
    lda #>$1234
    sta.z y1+1
    lda #<$1234
    sta.z y2
    lda #>$1234
    sta.z y2+1
    lda #<y1
    sta.z foo.y
    lda #>y1
    sta.z foo.y+1
    ldx #1
    jsr foo
    lda.z __1
    sta SCREEN
    lda.z __1+1
    sta SCREEN+1
    lda #<y2
    sta.z foo.y
    lda #>y2
    sta.z foo.y+1
    ldx #2
    jsr foo
    lda.z __3
    sta SCREEN+SIZEOF_SIGNED_WORD
    lda.z __3+1
    sta SCREEN+SIZEOF_SIGNED_WORD+1
    rts
}
// foo(byte register(X) x, signed word* zeropage(2) y)
foo: {
    .label return = 2
    .label y = 2
    txa
    asl
    tax
    clc
    ldy #0
    lda wow,x
    adc (return),y
    pha
    iny
    lda wow+1,x
    adc (return),y
    sta.z return+1
    pla
    sta.z return
    rts
}
  wow: .word $cafe, $babe, $1234, $5678
