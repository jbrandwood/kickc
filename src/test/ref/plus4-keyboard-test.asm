// Test reading keyboard port on the TED of the Plus/4
// C standard library string.h
// Functions to manipulate C strings and arrays.
.pc = $1001 "Basic"
:BasicUpstart(main)
.pc = $100d "Program"

  // Keyboard latch
  .label KEYBOARD_INPUT = $ff08
  // Keyboard scan
  .label KEYBOARD_SCAN = $fd30
  // Default address of screen character matrix
  .label DEFAULT_SCREEN = $c00
main: {
    .label row = 3
    .label y = 2
    // asm
    sei
    // memset(DEFAULT_SCREEN, ' ', 0x0400)
    jsr memset
  __b1:
    // for(char y=0;y<8;y++)
    lda.z y
    cmp #8
    bcc __b2
    lda #<DEFAULT_SCREEN
    sta.z row
    lda #>DEFAULT_SCREEN
    sta.z row+1
    lda #0
    sta.z y
    jmp __b1
  __b2:
    // 1<<y
    lda #1
    ldy.z y
    cpy #0
    beq !e+
  !:
    asl
    dey
    bne !-
  !e:
    // 0xff^(1<<y)
    eor #$ff
    // *KEYBOARD_SCAN = 0xff^(1<<y)
    sta KEYBOARD_SCAN
    // *KEYBOARD_INPUT = 0
    lda #0
    sta KEYBOARD_INPUT
    // key_bit = *KEYBOARD_INPUT^0xff
    lda #$ff
    eor KEYBOARD_INPUT
    tax
    ldy #0
  __b3:
    // for(char x=0;x<8;x++)
    cpy #8
    bcc __b4
    // row += 40
    lda #$28
    clc
    adc.z row
    sta.z row
    bcc !+
    inc.z row+1
  !:
    // for(char y=0;y<8;y++)
    inc.z y
    jmp __b1
  __b4:
    // key_bit&0x80
    txa
    and #$80
    // if(key_bit&0x80)
    cmp #0
    beq __b6
    // row[x] = '*'
    lda #'*'
    sta (row),y
  __b6:
    // key_bit <<= 1
    txa
    asl
    tax
    // for(char x=0;x<8;x++)
    iny
    jmp __b3
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $400
    .label str = DEFAULT_SCREEN
    .label end = str+num
    .label dst = 5
    lda #<str
    sta.z dst
    lda #>str
    sta.z dst+1
  __b1:
    // for(char* dst = str; dst!=end; dst++)
    lda.z dst+1
    cmp #>end
    bne __b2
    lda.z dst
    cmp #<end
    bne __b2
    // }
    rts
  __b2:
    // *dst = c
    lda #c
    ldy #0
    sta (dst),y
    // for(char* dst = str; dst!=end; dst++)
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b1
}
