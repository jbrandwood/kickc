// Test address-of an array element
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const SIZEOF_SIGNED_WORD = 2
  .label SCREEN = $400
  .label idx = 3
main: {
    .label i = 2
    lda #<VALS
    sta print.p
    lda #>VALS
    sta print.p+1
    lda #0
    sta idx
    jsr print
    lda #<VALS+1*SIZEOF_SIGNED_WORD
    sta print.p
    lda #>VALS+1*SIZEOF_SIGNED_WORD
    sta print.p+1
    jsr print
    lda #2
    sta i
  b1:
    lda i
    asl
    clc
    adc #<VALS
    sta print.p
    lda #>VALS
    adc #0
    sta print.p+1
    jsr print
    inc i
    lda #4
    cmp i
    bne b1
    rts
}
// print(signed word* zeropage(4) p)
print: {
    .label p = 4
    lda idx
    asl
    tax
    ldy #0
    lda (p),y
    sta SCREEN,x
    iny
    lda (p),y
    sta SCREEN+1,x
    inc idx
    rts
}
  VALS: .word 1, 2, 3, 4
