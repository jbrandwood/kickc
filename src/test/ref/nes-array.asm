// Test a bit of array code from the NES forum
// https://forums.nesdev.com/viewtopic.php?f=2&t=18735
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
main: {
    .label SCREEN = $400
    .label _1 = 2
    .label _3 = 2
    .label y1 = 4
    .label y2 = 6
    lda #<$1234
    sta y1
    lda #>$1234
    sta y1+1
    lda #<$1234
    sta y2
    lda #>$1234
    sta y2+1
    lda #<y1
    sta foo.y
    lda #>y1
    sta foo.y+1
    ldx #1
    jsr foo
    lda _1
    sta SCREEN
    lda _1+1
    sta SCREEN+1
    lda #<y2
    sta foo.y
    lda #>y2
    sta foo.y+1
    ldx #2
    jsr foo
    lda _3
    sta SCREEN+SIZEOF_SIGNED_WORD
    lda _3+1
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
    sta return+1
    pla
    sta return
    rts
}
  wow: .word $cafe, $babe, $1234, $5678
