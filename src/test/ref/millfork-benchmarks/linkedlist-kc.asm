// Print a number of zero-terminated strings, each followed by a newline.
// The sequence of lines is terminated by another zero.
.pc = $801 "Basic"
:BasicUpstart(__bbegin)
.pc = $80d "Program"
  .const OFFSET_STRUCT_NODE_VALUE = 2
  .label last_time = $a
  .label print_line_cursor = 6
  .label print_char_cursor = 8
  .label Ticks = $c
  .label free_ = 2
  .label root = 4
  .label Ticks_1 = $e
__bbegin:
  // last_time
  lda #<0
  sta.z last_time
  sta.z last_time+1
  jsr main
  rts
main: {
    .label __5 = $c
    .label i = 6
    // start()
    jsr start
    ldx #0
    lda #<$400
    sta.z print_char_cursor
    lda #>$400
    sta.z print_char_cursor+1
  __b1:
    // init()
    jsr init
    lda #<0
    sta.z root
    sta.z root+1
    sta.z free_
    sta.z free_+1
    sta.z i
    sta.z i+1
  __b2:
    // prepend(i)
    jsr prepend
    // for(i : 0..2999)
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
    // sum()
    jsr sum
    // print_char((byte)sum())
    lda.z __5
    jsr print_char
    // for(c : 0..4)
    inx
    cpx #5
    bne __b1
    // end()
    jsr end
    // }
    rts
}
end: {
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks
    lda.z last_time+1
    sta.z Ticks+1
    // start()
    jsr start
    // last_time -= Ticks
    lda.z last_time
    sec
    sbc.z Ticks
    sta.z last_time
    lda.z last_time+1
    sbc.z Ticks+1
    sta.z last_time+1
    // Ticks = last_time
    lda.z last_time
    sta.z Ticks_1
    lda.z last_time+1
    sta.z Ticks_1+1
    // print_uint(Ticks)
    jsr print_uint
    // print_ln()
    jsr print_ln
    // }
    rts
}
// Print a newline
print_ln: {
    lda #<$400
    sta.z print_line_cursor
    lda #>$400
    sta.z print_line_cursor+1
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor
    sta.z print_line_cursor
    bcc !+
    inc.z print_line_cursor+1
  !:
    // while (print_line_cursor<print_char_cursor)
    lda.z print_line_cursor+1
    cmp.z print_char_cursor+1
    bcc __b1
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b1
  !:
    // }
    rts
}
// Print a unsigned int as HEX
// print_uint(word zp($e) w)
print_uint: {
    .label w = $e
    // print_uchar(>w)
    ldx.z w+1
    jsr print_uchar
    // print_uchar(<w)
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a char as HEX
// print_uchar(byte register(X) b)
print_uchar: {
    // b>>4
    txa
    lsr
    lsr
    lsr
    lsr
    // print_char(print_hextab[b>>4])
    tay
    lda print_hextab,y
  // Table of hexadecimal digits
    jsr print_char
    // b&$f
    lda #$f
    axs #0
    // print_char(print_hextab[b&$f])
    lda print_hextab,x
    jsr print_char
    // }
    rts
}
// Print a single char
// print_char(byte register(A) ch)
print_char: {
    // *(print_char_cursor++) = ch
    ldy #0
    sta (print_char_cursor),y
    // *(print_char_cursor++) = ch;
    inc.z print_char_cursor
    bne !+
    inc.z print_char_cursor+1
  !:
    // }
    rts
}
start: {
    .label LAST_TIME = last_time
    // asm
    jsr $ffde
    sta LAST_TIME
    stx LAST_TIME+1
    // }
    rts
}
sum: {
    .label current = 4
    .label s = $c
    .label return = $c
    // current = root
    lda #<0
    sta.z s
    sta.z s+1
  __b1:
    // while (current)
    lda.z current+1
    cmp #>0
    bne __b2
    lda.z current
    cmp #<0
    bne __b2
    // }
    rts
  __b2:
    // s += current->value
    ldy #OFFSET_STRUCT_NODE_VALUE
    clc
    lda.z s
    adc (current),y
    sta.z s
    iny
    lda.z s+1
    adc (current),y
    sta.z s+1
    // current = current->next
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
// prepend(word zp(6) x)
prepend: {
    .label new = $10
    .label x = 6
    // alloc()
    jsr alloc
    // new = alloc()
    // new->next = root
    ldy #0
    lda.z root
    sta (new),y
    iny
    lda.z root+1
    sta (new),y
    // new->value = x
    ldy #OFFSET_STRUCT_NODE_VALUE
    lda.z x
    sta (new),y
    iny
    lda.z x+1
    sta (new),y
    // root = new
    lda.z new
    sta.z root
    lda.z new+1
    sta.z root+1
    // }
    rts
}
alloc: {
    .label __1 = $10
    .label return = $10
    // heap + free_
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
    // free_++;
    inc.z free_
    bne !+
    inc.z free_+1
  !:
    // }
    rts
}
init: {
    rts
}
  print_hextab: .text "0123456789abcdef"
  heap: .fill 4*$fa0, 0
