// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label textid = 2
main: {
    .label text = 5
    .label screen = 3
    lda #<0
    sta.z text
    sta.z text+1
    tax
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    txa
    sta.z textid
  __b1:
    jsr nexttext
  __b2:
    ldy #0
    lda (text),y
    cmp #0
    bne __b3
    inx
    cpx #$15
    bne __b1
    rts
  __b3:
    ldy #0
    lda (text),y
    sta (screen),y
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z text
    bne !+
    inc.z text+1
  !:
    jmp __b2
}
// Choose the next text to show - by updating the text pointer pointed to by the passed pointer to a pointer
nexttext: {
    .label textp = main.text
    lda #1
    and.z textid
    inc.z textid
    cmp #0
    beq __b1
    lda #<text2
    sta.z textp
    lda #>text2
    sta.z textp+1
    rts
  __b1:
    lda #<text1
    sta.z textp
    lda #>text1
    sta.z textp+1
    rts
}
  text1: .text "camelot "
  .byte 0
  text2: .text "rex "
  .byte 0
