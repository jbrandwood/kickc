.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  .const PLEX_COUNT = $a
  .label print_line_cursor = 2
  .label print_char_cursor = 4
  jsr main
main: {
    jsr plexInit
    jsr print_cls
    lda #<$400
    sta print_line_cursor
    lda #>$400
    sta print_line_cursor+1
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    jsr print_plex
    jsr plexSort
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_plex
    rts
}
print_plex: {
    ldx #0
  b1:
    lda PLEX_SORTED_IDX,x
    tay
    lda PLEX_YPOS,y
    sta print_byte.b
    jsr print_byte
    lda #' '
    jsr print_char
    inx
    cpx #PLEX_COUNT-1+1
    bne b1
    jsr print_ln
    rts
}
print_ln: {
  b1:
    lda print_line_cursor
    clc
    adc #$28
    sta print_line_cursor
    bcc !+
    inc print_line_cursor+1
  !:
    lda print_line_cursor+1
    cmp print_char_cursor+1
    bcc b1
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b1
  !:
    rts
}
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
print_byte: {
    .label b = 6
    lda b
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    and b
    tay
    lda print_hextab,y
    jsr print_char
    rts
}
plexSort: {
    .label nxt_idx = 7
    .label nxt_y = 8
    .label m = 6
    lda #0
    sta m
  b1:
    ldy m
    lda PLEX_SORTED_IDX+1,y
    sta nxt_idx
    tay
    lda PLEX_YPOS,y
    sta nxt_y
    ldx m
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcs b2
  b3:
    lda PLEX_SORTED_IDX,x
    sta PLEX_SORTED_IDX+1,x
    dex
    cpx #$ff
    bne b7
  b5:
    inx
    lda nxt_idx
    sta PLEX_SORTED_IDX,x
  b2:
    inc m
    lda m
    cmp #PLEX_COUNT-2+1
    bne b1
    rts
  b7:
    lda nxt_y
    ldy PLEX_SORTED_IDX,x
    cmp PLEX_YPOS,y
    bcc b3
    jmp b5
}
print_cls: {
    .label sc = 2
    lda #<$400
    sta sc
    lda #>$400
    sta sc+1
  b1:
    lda #' '
    ldy #0
    sta (sc),y
    inc sc
    bne !+
    inc sc+1
  !:
    lda sc+1
    cmp #>$400+$3e8
    bne b1
    lda sc
    cmp #<$400+$3e8
    bne b1
    rts
}
plexInit: {
    ldx #0
  b1:
    txa
    sta PLEX_SORTED_IDX,x
    inx
    cpx #PLEX_COUNT-1+1
    bne b1
    rts
}
  print_hextab: .text "0123456789abcdef"
  PLEX_YPOS: .byte $ff, $12, $11, $34, 2, $81, $77, $81, $ef, $11
  PLEX_SORTED_IDX: .fill PLEX_COUNT, 0
