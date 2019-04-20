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
  .const ENTRY_SIZE = $12
  // The maximal number of files
  .const MAX_FILES = $90
  .label print_char_cursor = 6
  .label print_line_cursor = $b
  .label print_line_cursor_32 = 2
  .label print_line_cursor_63 = 2
  .label print_line_cursor_159 = 2
  .label print_line_cursor_160 = 2
  .label print_line_cursor_161 = 2
  .label print_line_cursor_162 = 2
  .label print_line_cursor_163 = 2
  .label print_line_cursor_164 = 2
  .label print_line_cursor_165 = 2
  .label print_line_cursor_166 = 2
  .label print_line_cursor_167 = 2
  .label print_line_cursor_168 = 2
  .label print_line_cursor_169 = 2
  .label print_line_cursor_170 = 2
  .label print_line_cursor_171 = 2
  .label print_line_cursor_172 = 2
  .label print_line_cursor_173 = 2
  .label print_line_cursor_174 = 2
  .label print_line_cursor_175 = 2
  .label print_line_cursor_177 = 2
// Initialize 2 file entries and print them
main: {
    .const fileEntry1_idx = 1
    .const fileEntry2_idx = 2
    .label fileEntry1__0 = 4
    .label entry1 = 4
    .label fileEntry2__0 = 9
    .label entry2 = 9
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
    lda #0
    sta initEntry.n
    jsr initEntry
    lda entry2
    sta initEntry.entry
    lda entry2+1
    sta initEntry.entry+1
    lda #$80
    sta initEntry.n
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
    sta print_line_cursor_159
    lda print_line_cursor+1
    sta print_line_cursor_159+1
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    jsr print_ln
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
    sta print_line_cursor_161
    lda print_line_cursor+1
    sta print_line_cursor_161+1
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
    sta print_line_cursor_162
    lda print_line_cursor+1
    sta print_line_cursor_162+1
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
// print_str(byte* zeropage(2) str)
print_str: {
    .label str = 2
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
    sta print_line_cursor_177
    lda print_line_cursor+1
    sta print_line_cursor_177+1
    jmp b1
}
// Print the contents of a file entry
// printEntry(byte* zeropage(4) entry)
printEntry: {
    .label entry = 4
    .label entryBufDisk1__0 = 4
    .label entryBufDisk1_return = 2
    .label entryBufEdit1__0 = 2
    .label entryBufEdit1_return = 2
    .label entryTsLen1__0 = 2
    .label entryTsLen1_return = 2
    .label entryTsOrder1__0 = 2
    .label entryTsOrder1_return = 2
    .label entryTLastLink1_return = 2
    .label entrySLastLink1_return = 2
    .label entryBFlag1_return = 2
    .label entryBError1_return = 2
    .label entryUCross1__0 = 2
    .label entryUCross1_return = 2
    .label entryBAddrLo1_return = 2
    .label entryBAddrHi1_return = 2
    .label entryTHi1_return = 2
    .label entryTLo1_return = 4
    lda print_line_cursor
    sta print_char_cursor
    lda print_line_cursor+1
    sta print_char_cursor+1
    lda #<str
    sta print_str.str
    lda #>str
    sta print_str.str+1
    jsr print_str
    lda entryBufDisk1__0
    sta entryBufDisk1_return
    lda entryBufDisk1__0+1
    sta entryBufDisk1_return+1
    ldy #0
    lda (print_word.w),y
    tax
    iny
    lda (print_word.w),y
    sta print_word.w+1
    stx print_word.w
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
    lda #<str1
    sta print_str.str
    lda #>str1
    sta print_str.str+1
    jsr print_str
    lda entryBufDisk1__0
    clc
    adc #2
    sta entryBufEdit1__0
    lda entryBufDisk1__0+1
    adc #0
    sta entryBufEdit1__0+1
    ldy #0
    lda (print_word.w),y
    tax
    iny
    lda (print_word.w),y
    sta print_word.w+1
    stx print_word.w
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
    lda #<str2
    sta print_str.str
    lda #>str2
    sta print_str.str+1
    jsr print_str
    lda #4
    clc
    adc entryBufDisk1__0
    sta entryTsLen1__0
    lda #0
    adc entryBufDisk1__0+1
    sta entryTsLen1__0+1
    ldy #0
    lda (print_word.w),y
    tax
    iny
    lda (print_word.w),y
    sta print_word.w+1
    stx print_word.w
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_165
    lda print_line_cursor+1
    sta print_line_cursor_165+1
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
    lda #6
    clc
    adc entryBufDisk1__0
    sta entryTsOrder1__0
    lda #0
    adc entryBufDisk1__0+1
    sta entryTsOrder1__0+1
    ldy #0
    lda (print_word.w),y
    tax
    iny
    lda (print_word.w),y
    sta print_word.w+1
    stx print_word.w
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_166
    lda print_line_cursor+1
    sta print_line_cursor_166+1
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
    lda #8
    clc
    adc entryBufDisk1__0
    sta entryTLastLink1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryTLastLink1_return+1
    ldy #0
    lda (entryTLastLink1_return),y
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
    lda #<str5
    sta print_str.str
    lda #>str5
    sta print_str.str+1
    jsr print_str
    lda #9
    clc
    adc entryBufDisk1__0
    sta entrySLastLink1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entrySLastLink1_return+1
    ldy #0
    lda (entrySLastLink1_return),y
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
    lda #<str6
    sta print_str.str
    lda #>str6
    sta print_str.str+1
    jsr print_str
    lda #$a
    clc
    adc entryBufDisk1__0
    sta entryBFlag1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryBFlag1_return+1
    ldy #0
    lda (entryBFlag1_return),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_169
    lda print_line_cursor+1
    sta print_line_cursor_169+1
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
    lda #$b
    clc
    adc entryBufDisk1__0
    sta entryBError1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryBError1_return+1
    ldy #0
    lda (entryBError1_return),y
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
    lda #<str8
    sta print_str.str
    lda #>str8
    sta print_str.str+1
    jsr print_str
    lda #$c
    clc
    adc entryBufDisk1__0
    sta entryUCross1__0
    lda #0
    adc entryBufDisk1__0+1
    sta entryUCross1__0+1
    ldy #0
    lda (print_word.w),y
    tax
    iny
    lda (print_word.w),y
    sta print_word.w+1
    stx print_word.w
    jsr print_word
    lda print_line_cursor
    sta print_line_cursor_171
    lda print_line_cursor+1
    sta print_line_cursor_171+1
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
    lda #$e
    clc
    adc entryBufDisk1__0
    sta entryBAddrLo1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryBAddrLo1_return+1
    ldy #0
    lda (entryBAddrLo1_return),y
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
    lda #<str10
    sta print_str.str
    lda #>str10
    sta print_str.str+1
    jsr print_str
    lda #$f
    clc
    adc entryBufDisk1__0
    sta entryBAddrHi1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryBAddrHi1_return+1
    ldy #0
    lda (entryBAddrHi1_return),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_173
    lda print_line_cursor+1
    sta print_line_cursor_173+1
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
    lda #$10
    clc
    adc entryBufDisk1__0
    sta entryTHi1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryTHi1_return+1
    ldy #0
    lda (entryTHi1_return),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_174
    lda print_line_cursor+1
    sta print_line_cursor_174+1
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
    lda #$11
    clc
    adc entryTLo1_return
    sta entryTLo1_return
    bcc !+
    inc entryTLo1_return+1
  !:
    ldy #0
    lda (entryTLo1_return),y
    tax
    jsr print_byte
    lda print_line_cursor
    sta print_line_cursor_175
    lda print_line_cursor+1
    sta print_line_cursor_175+1
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
// print_word(word zeropage(2) w)
print_word: {
    .label w = 2
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
// initEntry(byte* zeropage(2) entry, byte zeropage(8) n)
initEntry: {
    .label entry = 2
    .label entryBufDisk1__0 = 2
    .label entryBufDisk1_return = 6
    .label entryBufEdit1__0 = 6
    .label entryBufEdit1_return = 6
    .label entryTsLen1__0 = 6
    .label entryTsLen1_return = 6
    .label entryTsOrder1__0 = 6
    .label entryTsOrder1_return = 6
    .label entryTLastLink1_return = 6
    .label entrySLastLink1_return = 6
    .label entryBFlag1_return = 6
    .label entryBError1_return = 6
    .label entryUCross1__0 = 6
    .label entryUCross1_return = 6
    .label entryBAddrLo1_return = 6
    .label entryBAddrHi1_return = 6
    .label entryTHi1_return = 6
    .label entryTLo1_return = 2
    .label n = 8
    lda entryBufDisk1__0
    sta entryBufDisk1_return
    lda entryBufDisk1__0+1
    sta entryBufDisk1_return+1
    lda n
    clc
    adc #1
    ldy #0
    sta (entryBufDisk1_return),y
    tya
    iny
    sta (entryBufDisk1_return),y
    lda entryBufDisk1__0
    clc
    adc #2
    sta entryBufEdit1__0
    lda entryBufDisk1__0+1
    adc #0
    sta entryBufEdit1__0+1
    lda n
    clc
    adc #2
    ldy #0
    sta (entryBufEdit1_return),y
    tya
    iny
    sta (entryBufEdit1_return),y
    lda #4
    clc
    adc entryBufDisk1__0
    sta entryTsLen1__0
    lda #0
    adc entryBufDisk1__0+1
    sta entryTsLen1__0+1
    lda #3
    clc
    adc n
    ldy #0
    sta (entryTsLen1_return),y
    tya
    iny
    sta (entryTsLen1_return),y
    lda #6
    clc
    adc entryBufDisk1__0
    sta entryTsOrder1__0
    lda #0
    adc entryBufDisk1__0+1
    sta entryTsOrder1__0+1
    lda #4
    clc
    adc n
    ldy #0
    sta (entryTsOrder1_return),y
    tya
    iny
    sta (entryTsOrder1_return),y
    lda #8
    clc
    adc entryBufDisk1__0
    sta entryTLastLink1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryTLastLink1_return+1
    lda #5
    clc
    adc n
    ldy #0
    sta (entryTLastLink1_return),y
    lda #9
    clc
    adc entryBufDisk1__0
    sta entrySLastLink1_return
    tya
    adc entryBufDisk1__0+1
    sta entrySLastLink1_return+1
    lda #6
    clc
    adc n
    sta (entrySLastLink1_return),y
    lda #$a
    clc
    adc entryBufDisk1__0
    sta entryBFlag1_return
    tya
    adc entryBufDisk1__0+1
    sta entryBFlag1_return+1
    lda #7
    clc
    adc n
    sta (entryBFlag1_return),y
    lda #$b
    clc
    adc entryBufDisk1__0
    sta entryBError1_return
    tya
    adc entryBufDisk1__0+1
    sta entryBError1_return+1
    lda #8
    clc
    adc n
    sta (entryBError1_return),y
    lda #$c
    clc
    adc entryBufDisk1__0
    sta entryUCross1__0
    tya
    adc entryBufDisk1__0+1
    sta entryUCross1__0+1
    lda #9
    clc
    adc n
    sta (entryUCross1_return),y
    tya
    iny
    sta (entryUCross1_return),y
    lda #$e
    clc
    adc entryBufDisk1__0
    sta entryBAddrLo1_return
    lda #0
    adc entryBufDisk1__0+1
    sta entryBAddrLo1_return+1
    lda #$a
    clc
    adc n
    ldy #0
    sta (entryBAddrLo1_return),y
    lda #$f
    clc
    adc entryBufDisk1__0
    sta entryBAddrHi1_return
    tya
    adc entryBufDisk1__0+1
    sta entryBAddrHi1_return+1
    lda #$b
    clc
    adc n
    sta (entryBAddrHi1_return),y
    lda #$10
    clc
    adc entryBufDisk1__0
    sta entryTHi1_return
    tya
    adc entryBufDisk1__0+1
    sta entryTHi1_return+1
    lda #$c
    clc
    adc n
    sta (entryTHi1_return),y
    lda #$11
    clc
    adc entryTLo1_return
    sta entryTLo1_return
    bcc !+
    inc entryTLo1_return+1
  !:
    lda #$d
    clc
    adc n
    ldy #0
    sta (entryTLo1_return),y
    rts
}
// Perform binary multiplication of two unsigned 8-bit bytes into a 16-bit unsigned word
// mul8u(byte register(X) a)
mul8u: {
    .label mb = 2
    .label res = 9
    .label return = 9
    lda #ENTRY_SIZE
    sta mb
    lda #0
    sta mb+1
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
  files: .fill MAX_FILES*ENTRY_SIZE, 0
