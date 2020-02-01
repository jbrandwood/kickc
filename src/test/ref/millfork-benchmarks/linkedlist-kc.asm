.pc = $801 "Basic"
:BasicUpstart(__b1)
.pc = $80d "Program"
  .const OFFSET_STRUCT_NODE_VALUE = 2
  .label print_line_cursor = 4
  .label print_char_cursor = 6
  .label last_time = $a
  .label rand_seed = $c
  .label Ticks = $10
  .label Ticks_1 = $e
  .label free_ = 8
  .label root = 2
__b1:
  lda #<0
  sta.z last_time
  sta.z last_time+1
  sta.z rand_seed
  sta.z rand_seed+1
  jsr main
  rts
main: {
    .label __5 = 8
    .label i = 4
    jsr start
    ldx #0
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
  __b1:
    jsr init
    lda #<0
    sta.z root
    sta.z root+1
    sta.z free_
    sta.z free_+1
    sta.z i
    sta.z i+1
  __b2:
    jsr prepend
    inc.z i
    bne !+
    inc.z i+1
  !:
    lda.z i+1
    cmp #>$bb8
    bne __b2
    lda.z i
    cmp #<$bb8
    bne __b2
    jsr sum
    lda.z __5
    jsr print_char
    inx
    cpx #5
    bne __b1
    jsr end
    rts
}
end: {
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    jsr start
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    jsr print_word
    jsr print_ln
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage($e) w)
print_word: {
    .label w = $e
    lda.z w+1
    tax
    jsr print_byte
    lda.z w
    tax
    jsr print_byte
    rts
}
// Print a byte as HEX
// print_byte(byte register(X) b)
print_byte: {
    txa
    lsr
    lsr
    lsr
    lsr
    tay
    lda print_hextab,y
    jsr print_char
    lda #$f
    axs #0
    lda print_hextab,x
    jsr print_char
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    ldy #0
    sta (print_char_cursor),y
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    rts
}
start: {
    .label LAST_TIME = last_time
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    lda #<$194a
    sta.z rand_seed
    lda #>$194a
    sta.z rand_seed+1
    rts
}
sum: {
    .label current = 2
    .label s = 8
    .label return = 8
    lda #<0
    sta.z s
    sta.z s+1
  __b1:
    lda.z current+1
    cmp #>0
    bne __b2
    lda.z current
    cmp #<0
    bne __b2
    rts
  __b2:
    ldy #OFFSET_STRUCT_NODE_VALUE
    clc
    lda.z s
    adc (current),y
    sta.z s
    iny
    lda.z s+1
    adc (current),y
    sta.z s+1
    ldy #0
    lda (current),y
    pha
    iny
    lda (current),y
    sta.z current+1
    pla
    sta.z current
    jmp __b1
}
// prepend(word zeropage(4) x)
prepend: {
    .label new = $10
    .label x = 4
    jsr alloc
    ldy #0
    lda.z root
    sta (new),y
    iny
    lda.z root+1
    sta (new),y
    ldy #OFFSET_STRUCT_NODE_VALUE
    lda.z x
    sta (new),y
    iny
    lda.z x+1
    sta (new),y
    lda.z new
    sta.z root
    lda.z new+1
    sta.z root+1
    rts
}
alloc: {
    .label __1 = $10
    .label return = $10
    lda.z free_
    asl
    sta.z __1
    lda.z free_+1
    rol
    sta.z __1+1
    asl.z __1
    rol.z __1+1
    clc
    lda.z return
    adc #<heap
    sta.z return
    lda.z return+1
    adc #>heap
    sta.z return+1
    inc.z free_
    bne !+
    inc.z free_+1
  !:
    rts
}
init: {
    rts
}
  print_hextab: .text "0123456789abcdef"
  heap: .fill 4*$fa0, 0
