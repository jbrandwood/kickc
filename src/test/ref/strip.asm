// Tests of strip() function from https://news.ycombinator.com/item?id=12080871
  // Commodore 64 PRG executable file
.file [name="strip.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .label screen = 6
.segment Code
main: {
    // strip(msg1, ' ')
    ldx #' '
    lda #<msg1
    sta.z strip.dest
    lda #>msg1
    sta.z strip.dest+1
    jsr strip
    // print(msg1)
    lda #<$400
    sta.z screen
    lda #>$400
    sta.z screen+1
    lda #<msg1
    sta.z print.msg
    lda #>msg1
    sta.z print.msg+1
    jsr print
    // strip(msg2, 'y')
    ldx #'y'
    lda #<msg2
    sta.z strip.dest
    lda #>msg2
    sta.z strip.dest+1
    jsr strip
    // print(msg2)
    lda #<msg2
    sta.z print.msg
    lda #>msg2
    sta.z print.msg+1
    jsr print
    // }
    rts
}
// void strip(__zp(8) char *p, __register(X) char c)
strip: {
    .label dest = 4
    .label p = 8
    .label p_1 = 2
    lda.z dest
    sta.z p_1
    lda.z dest+1
    sta.z p_1+1
  __b1:
    // if(*p!=c)
    txa
    ldy #0
    cmp (p_1),y
    beq __b2
    // *dest++=*p
    lda (p_1),y
    sta (dest),y
    // *dest++=*p;
    inc.z dest
    bne !+
    inc.z dest+1
  !:
  __b2:
    // while(*p++!=0)
    clc
    lda.z p_1
    adc #1
    sta.z p
    lda.z p_1+1
    adc #0
    sta.z p+1
    ldy #0
    lda (p_1),y
    cmp #0
    bne __b4
    // }
    rts
  __b4:
    lda.z p
    sta.z p_1
    lda.z p+1
    sta.z p_1+1
    jmp __b1
}
// void print(__zp(2) char *msg)
print: {
    .label msg = 2
  __b1:
    // *screen++ = *msg++
    ldy #0
    lda (msg),y
    sta (screen),y
    // *screen++ = *msg++;
    inc.z screen
    bne !+
    inc.z screen+1
  !:
    inc.z msg
    bne !+
    inc.z msg+1
  !:
    // while(*msg!=0)
    ldy #0
    lda (msg),y
    cmp #0
    bne __b1
    // }
    rts
}
.segment Data
  msg1: .text "hello world!"
  .byte 0
  msg2: .text "goodbye blue sky!"
  .byte 0
