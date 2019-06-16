// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label textid = 4
main: {
    .label text = 2
    .label screen = 5
    lda #<0
    sta text
    sta text+1
    tax
    lda #<$400
    sta screen
    lda #>$400
    sta screen+1
    txa
    sta textid
  b1:
    jsr nexttext
  b2:
    ldy #0
    lda (text),y
    cmp #'@'
    bne b3
    inx
    cpx #$15
    bne b1
    rts
  b3:
    ldy #0
    lda (text),y
    sta (screen),y
    inc screen
    bne !+
    inc screen+1
  !:
    inc text
    bne !+
    inc text+1
  !:
    jmp b2
}
// Choose the next text to show - by updating the text pointer pointed to by the passed pointer to a pointer
nexttext: {
    .label textp = main.text
    lda #1
    and textid
    inc textid
    cmp #0
    beq b1
    lda #<text2
    sta textp
    lda #>text2
    sta textp+1
    rts
  b1:
    lda #<text1
    sta textp
    lda #>text1
    sta textp+1
    rts
}
  text1: .text "camelot @"
  text2: .text "rex @"
