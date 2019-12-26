// Test address-of an array element
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label SCREEN = $400
  .const SIZEOF_SIGNED_WORD = 2
  .label idx = 3
main: {
    .label i = 2
    lda #<VALS
    sta.z print.p
    lda #>VALS
    sta.z print.p+1
    lda #0
    sta.z idx
    jsr print
    lda #<VALS+1*SIZEOF_SIGNED_WORD
    sta.z print.p
    lda #>VALS+1*SIZEOF_SIGNED_WORD
    sta.z print.p+1
    jsr print
    lda #2
    sta.z i
  __b1:
    lda.z i
    asl
    clc
    adc #<VALS
    sta.z print.p
    lda #>VALS
    adc #0
    sta.z print.p+1
    jsr print
    inc.z i
    lda #4
    cmp.z i
    bne __b1
    rts
}
// print(signed word* zp(4) p)
print: {
    .label p = 4
    lda.z idx
    asl
    tax
    ldy #0
    lda (p),y
    sta SCREEN,x
    iny
    lda (p),y
    sta SCREEN+1,x
    inc.z idx
    rts
}
  VALS: .word 1, 2, 3, 4
