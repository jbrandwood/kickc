// Implementing a semi-struct without the struct keyword by using pointer math and inline functions
//
// struct fileentry {
//    BYTE *bufDisk; // file position in disk buffer.
//    BYTE *bufEdit; // file edits
//    WORD tsLen; // num of sectors
//    TS *tsOrder;
//    BYTE tLastLink;
//    BYTE sLastLink;
//    BYTE bFlag;
//    BYTE bError;
//    WORD uCross; // num of crosslinked sectors
//    BYTE bAddrLo; // start address
//    BYTE bAddrHi;
//    BYTE tHi; // highest track
//    BYTE tLo; // lowest track
//    };
//    typedef struct fileentry ENTRY;
//    ENTRY files[MAX_FILES];
.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
  // CIA#1 Port A: keyboard matrix columns and joystick #2
  .label CIA1_PORT_A = $dc00
  // CIA#1 Port B: keyboard matrix rows and joystick #1.
  .label CIA1_PORT_B = $dc01
  // CIA #1 Port A data direction register.
  .label CIA1_PORT_A_DDR = $dc02
  // CIA #1 Port B data direction register.
  .label CIA1_PORT_B_DDR = $dc03
  .const KEY_SPACE = $3c
  // The size of a file ENTRY
  .const SIZEOF_ENTRY = $12
  // The maximal number of files
  .const MAX_FILES = $90
  .label print_char_cursor = 4
  .label print_line_cursor = 8
  .label print_line_cursor_32 = $a
  .label print_line_cursor_63 = $a
  .label print_line_cursor_157 = $a
  .label print_line_cursor_158 = $a
  .label print_line_cursor_159 = $a
  .label print_line_cursor_160 = $a
  .label print_line_cursor_161 = $a
  .label print_line_cursor_162 = $a
  .label print_line_cursor_163 = $a
  .label print_line_cursor_164 = $a
  .label print_line_cursor_165 = $a
  .label print_line_cursor_166 = $a
  .label print_line_cursor_167 = $a
  .label print_line_cursor_168 = $a
  .label print_line_cursor_169 = $a
  .label print_line_cursor_170 = $a
  .label print_line_cursor_171 = $a
  .label print_line_cursor_172 = $a
  .label print_line_cursor_173 = $a
  .label print_line_cursor_175 = $a
// Initialize 2 file entries and print them
main: {
    .const fileEntry1_idx = 1
    .const fileEntry2_idx = 2
    .label fileEntry1__0 = 2
    .label entry1 = 2
    .label fileEntry2__0 = 6
    .label entry2 = 6
    jsr keyboard_init
    ldx #fileEntry1_idx
    jsr mul8u
    lda mul8u.return
    sta fileEntry1__0
    lda mul8u.return+1
    sta fileEntry1__0+1
    clc
    lda entry1
    adc #<files
    sta entry1
    lda entry1+1
    adc #>files
    sta entry1+1
    ldx #fileEntry2_idx
    jsr mul8u
    clc
    lda entry2
    adc #<files
    sta entry2
    lda entry2+1
    adc #>files
    sta entry2+1
    lda entry1
    sta initEntry.entry
    lda entry1+1
    sta initEntry.entry+1
    ldx #0
    jsr initEntry
    lda entry2
    sta initEntry.entry
    lda entry2+1
    sta initEntry.entry+1
    ldx #$11
    jsr initEntry
    jsr print_cls
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor_63
    lda #>$400
    sta print_line_cursor_63+1
    jsr print_ln
    lda print_line_cursor
    sta print_line_cursor_157
    lda print_line_cursor+1
    sta print_line_cursor_157+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_ln
    jsr printEntry
    lda print_line_cursor
    sta print_line_cursor_158
    lda print_line_cursor+1
    sta print_line_cursor_158+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
  b1:
    jsr keyboard_key_pressed
    cmp #0
    beq b1
    jsr print_cls
    lda #<$400
    sta print_char_cursor
    lda #>$400
    sta print_char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #<$400
    sta print_line_cursor_63
    lda #>$400
    sta print_line_cursor_63+1
    jsr print_ln
    lda print_line_cursor
    sta print_line_cursor_159
    lda print_line_cursor+1
    sta print_line_cursor_159+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_ln
    lda entry2
    sta printEntry.entry
    lda entry2+1
    sta printEntry.entry+1
    jsr printEntry
    lda print_line_cursor
    sta print_line_cursor_160
    lda print_line_cursor+1
    sta print_line_cursor_160+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
  b3:
    jsr keyboard_key_pressed
    cmp #0
    beq b3
    jsr print_cls
    rts
    str: .text "** entry 1 **@"
    str1: .text "- press space -@"
    str2: .text "** entry 2 **@"
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    jsr memset
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = $400
    .label end = str+num
    .label dst = $a
    lda #<str
    sta dst
    lda #>str
    sta dst+1
  b1:
    lda dst+1
    cmp #>end
    bne b2
    lda dst
    cmp #<end
    bne b2
    rts
  b2:
    lda #c
    ldy #0
    sta (dst),y
    inc dst
    bne !+
    inc dst+1
  !:
    jmp b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    jsr keyboard_matrix_read
    and keyboard_matrix_col_bitmask+colidx
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
keyboard_matrix_read: {
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1_PORT_A
    lda CIA1_PORT_B
    eor #$ff
    rts
}
// Print a zero-terminated string
// print_str(byte* zeropage($a) str)
print_str: {
    .label str = $a
  b1:
    ldy #0
    lda (str),y
    cmp #'@'
    bne b2
    rts
  b2:
    ldy #0
    lda (str),y
    sta (print_char_cursor),y
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    inc str
    bne !+
    inc str+1
  !:
    jmp b1
}
// Print a newline
print_ln: {
  b1:
    lda #$28
    clc
    adc print_line_cursor_32
    sta print_line_cursor
    lda #0
    adc print_line_cursor_32+1
    sta print_line_cursor+1
    cmp print_char_cursor+1
    bcc b2
    bne !+
    lda print_line_cursor
    cmp print_char_cursor
    bcc b2
  !:
    rts
  b2:
    lda print_line_cursor
    sta print_line_cursor_175
    lda print_line_cursor+1
    sta print_line_cursor_175+1
    jmp b1
}
// Print the contents of a file entry
// printEntry(byte* zeropage(2) entry)
printEntry: {
    .label entry = 2
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    ldy #0
    lda (entry),y
    sta print_word.w
    iny
    lda (entry),y
    sta print_word.w+1
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_161
    lda print_line_cursor+1
    sta print_line_cursor_161+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    ldy #2
    lda (entry),y
    sta print_word.w
    iny
    lda (entry),y
    sta print_word.w+1
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_162
    lda print_line_cursor+1
    sta print_line_cursor_162+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    ldy #4
    lda (entry),y
    sta print_word.w
    iny
    lda (entry),y
    sta print_word.w+1
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_163
    lda print_line_cursor+1
    sta print_line_cursor_163+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str3
    sta print_str.str
    lda #>str3
    sta print_str.str+1
    jsr print_str
    ldy #6
    lda (entry),y
    sta print_word.w
    iny
    lda (entry),y
    sta print_word.w+1
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_164
    lda print_line_cursor+1
    sta print_line_cursor_164+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str4
    sta print_str.str
    lda #>str4
    sta print_str.str+1
    jsr print_str
    ldy #8
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_165
    lda print_line_cursor+1
    sta print_line_cursor_165+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    ldy #9
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_166
    lda print_line_cursor+1
    sta print_line_cursor_166+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str6
    sta print_str.str
    lda #>str6
    sta print_str.str+1
    jsr print_str
    ldy #$a
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_167
    lda print_line_cursor+1
    sta print_line_cursor_167+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str7
    sta print_str.str
    lda #>str7
    sta print_str.str+1
    jsr print_str
    ldy #$b
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_168
    lda print_line_cursor+1
    sta print_line_cursor_168+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str8
    sta print_str.str
    lda #>str8
    sta print_str.str+1
    jsr print_str
    ldy #$c
    lda (entry),y
    sta print_word.w
    iny
    lda (entry),y
    sta print_word.w+1
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_169
    lda print_line_cursor+1
    sta print_line_cursor_169+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str9
    sta print_str.str
    lda #>str9
    sta print_str.str+1
    jsr print_str
    ldy #$e
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_170
    lda print_line_cursor+1
    sta print_line_cursor_170+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str10
    sta print_str.str
    lda #>str10
    sta print_str.str+1
    jsr print_str
    ldy #$f
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_171
    lda print_line_cursor+1
    sta print_line_cursor_171+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str11
    sta print_str.str
    lda #>str11
    sta print_str.str+1
    jsr print_str
    ldy #$10
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_172
    lda print_line_cursor+1
    sta print_line_cursor_172+1
    jsr print_ln
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str12
    sta print_str.str
    lda #>str12
    sta print_str.str+1
    jsr print_str
    ldy #$11
    lda (entry),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_173
    lda print_line_cursor+1
    sta print_line_cursor_173+1
    jsr print_ln
    rts
    str: .text "bufdisk   @"
    str1: .text "bufedit   @"
    str2: .text "tslen     @"
    str3: .text "tsorder   @"
    str4: .text "tlastlink   @"
    str5: .text "slastlink   @"
    str6: .text "bflag       @"
    str7: .text "berror      @"
    str8: .text "ucross    @"
    str9: .text "baddrlo     @"
    str10: .text "baddrhi     @"
    str11: .text "thi         @"
    str12: .text "tlo         @"
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
    inc print_char_cursor
    bne !+
    inc print_char_cursor+1
  !:
    rts
}
// Print a word as HEX
// print_word(word zeropage($a) w)
print_word: {
    .label w = $a
    lda w+1
    tax
    jsr print_byte
    lda w
    tax
    jsr print_byte
    rts
}
// Set all values in the passed struct
// Sets the values to n, n+1, n... to help test that everything works as intended
// initEntry(byte* zeropage(4) entry, byte register(X) n)
initEntry: {
    .label _1 = 8
    .label _3 = $a
    .label _5 = $c
    .label _7 = $e
    .label _17 = $10
    .label entry = 4
    txa
    clc
    adc #<$1111
    sta _1
    lda #>$1111
    adc #0
    sta _1+1
    ldy #0
    lda _1
    sta (entry),y
    iny
    lda _1+1
    sta (entry),y
    txa
    clc
    adc #<$2222
    sta _3
    lda #>$2222
    adc #0
    sta _3+1
    ldy #2
    lda _3
    sta (entry),y
    iny
    lda _3+1
    sta (entry),y
    txa
    clc
    adc #<$3333
    sta _5
    lda #>$3333
    adc #0
    sta _5+1
    ldy #4
    lda _5
    sta (entry),y
    iny
    lda _5+1
    sta (entry),y
    txa
    clc
    adc #<$4444
    sta _7
    lda #>$4444
    adc #0
    sta _7+1
    ldy #6
    lda _7
    sta (entry),y
    iny
    lda _7+1
    sta (entry),y
    txa
    clc
    adc #$55
    ldy #8
    sta (entry),y
    txa
    clc
    adc #$66
    ldy #9
    sta (entry),y
    txa
    clc
    adc #$77
    ldy #$a
    sta (entry),y
    txa
    clc
    adc #$88
    ldy #$b
    sta (entry),y
    txa
    clc
    adc #<$9999
    sta _17
    lda #>$9999
    adc #0
    sta _17+1
    ldy #$c
    lda _17
    sta (entry),y
    iny
    lda _17+1
    sta (entry),y
    txa
    clc
    adc #$aa
    ldy #$e
    sta (entry),y
    txa
    clc
    adc #$bb
    ldy #$f
    sta (entry),y
    txa
    clc
    adc #$cc
    ldy #$10
    sta (entry),y
    txa
    clc
    adc #$dd
    ldy #$11
    sta (entry),y
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .label mb = 8
    .label res = 6
    .label return = 6
    lda #<SIZEOF_ENTRY
    sta mb
    lda #>SIZEOF_ENTRY
    sta mb+1
    lda #<0
    sta res
    sta res+1
  b1:
    cpx #0
    bne b2
    rts
  b2:
    txa
    and #1
    cmp #0
    beq b3
    lda res
    clc
    adc mb
    sta res
    lda res+1
    adc mb+1
    sta res+1
  b3:
    txa
    lsr
    tax
    asl mb
    rol mb+1
    jmp b1
}
// Initialize keyboard reading by setting CIA#$ Data Direction Registers
keyboard_init: {
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1_PORT_A_DDR
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1_PORT_B_DDR
    rts
}
  print_hextab: .text "0123456789abcdef"
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // All files
  files: .fill MAX_FILES*SIZEOF_ENTRY, 0
