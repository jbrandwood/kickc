// Tests pointer to pointer in a more complex setup
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .label textid = 4
main: {
    .label text = 2
    .label screen = 5
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
  b1:
    jsr nexttext
  b2:
    ldy #0
    lda (text),y
    cmp #0
    bne b3
    inx
    cpx #$15
    bne b1
    rts
  b3:
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
    jmp b2
}
// Choose the next text to show - by updating the text pointer pointed to by the passed pointer to a pointer
nexttext: {
    .label textp = main.text
    lda #1
    and.z textid
    inc.z textid
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
  text1: .text "camelot "
  .byte 0
  text2: .text "rex "
  .byte 0
