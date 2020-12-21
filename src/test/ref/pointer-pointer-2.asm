// Tests pointer to pointer in a more complex setup
  // Commodore 64 PRG executable file
.file [name="pointer-pointer-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label textid = 2
.segment Code
main: {
    .label text = 5
    .label screen = 3
    // text
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
    // nexttext(&text)
    jsr nexttext
  __b2:
    // while(*text)
    ldy #0
    lda (text),y
    cmp #0
    bne __b3
    // for(byte i: 0..20)
    inx
    cpx #$15
    bne __b1
    // }
    rts
  __b3:
    // *screen++ = *text++
    ldy #0
    lda (text),y
    sta (screen),y
    // *screen++ = *text++;
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
    // textid++&1
    lda #1
    and.z textid
    // if((textid++&1)==0)
    inc.z textid
    cmp #0
    beq __b1
    // *textp = text2
    lda #<text2
    sta.z textp
    lda #>text2
    sta.z textp+1
    // }
    rts
  __b1:
    // *textp = text1
    lda #<text1
    sta.z textp
    lda #>text1
    sta.z textp+1
    rts
}
.segment Data
  text1: .text "camelot "
  .byte 0
  text2: .text "rex "
  .byte 0
