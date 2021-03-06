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
  // Commodore 64 PRG executable file
.file [name="semi-struct-2.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const KEY_SPACE = $3c
  // The size of a file ENTRY
  .const SIZEOF_ENTRY = $12
  // The maximal number of files
  .const MAX_FILES = $90
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR = 3
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .label print_screen = $400
  .label print_char_cursor = 2
  .label print_line_cursor = $a
  .label print_line_cursor_1 = 4
.segment Code
// Initialize 2 file entries and print them
main: {
    .const fileEntry1_idx = 1
    .const fileEntry2_idx = 2
    .label fileEntry1___0 = 6
    .label fileEntry2___0 = 6
    .label entry1 = $10
    .label entry2 = 6
    // keyboard_init()
    jsr keyboard_init
    // mul8u(idx, SIZEOF_ENTRY)
    ldx #fileEntry1_idx
    jsr mul8u
    // mul8u(idx, SIZEOF_ENTRY)
    // files+mul8u(idx, SIZEOF_ENTRY)
    lda.z fileEntry1___0
    clc
    adc #<files
    sta.z entry1
    lda.z fileEntry1___0+1
    adc #>files
    sta.z entry1+1
    // mul8u(idx, SIZEOF_ENTRY)
    ldx #fileEntry2_idx
    jsr mul8u
    // mul8u(idx, SIZEOF_ENTRY)
    // files+mul8u(idx, SIZEOF_ENTRY)
    lda.z entry2
    clc
    adc #<files
    sta.z entry2
    lda.z entry2+1
    adc #>files
    sta.z entry2+1
    // initEntry(entry1,0x00)
    lda.z entry1
    sta.z initEntry.entry
    lda.z entry1+1
    sta.z initEntry.entry+1
    ldx #0
    jsr initEntry
    // initEntry(entry2,0x11)
    lda.z entry2
    sta.z initEntry.entry
    lda.z entry2+1
    sta.z initEntry.entry+1
    ldx #$11
    jsr initEntry
    // print_cls()
    jsr print_cls
    // print_str("** entry 1 **")
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor_1
    lda #>print_screen
    sta.z print_line_cursor_1+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_ln()
    jsr print_ln
    // printEntry(entry1)
    jsr printEntry
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("- press space -")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
  __b1:
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // while(keyboard_key_pressed(KEY_SPACE)==0)
    cmp #0
    beq __b1
    // print_cls()
    jsr print_cls
    // print_str("** entry 2 **")
    lda #<print_screen
    sta.z print_char_cursor
    lda #>print_screen
    sta.z print_char_cursor+1
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_ln()
    lda #<print_screen
    sta.z print_line_cursor_1
    lda #>print_screen
    sta.z print_line_cursor_1+1
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_ln()
    jsr print_ln
    // printEntry(entry2)
    lda.z entry2
    sta.z printEntry.entry
    lda.z entry2+1
    sta.z printEntry.entry+1
    jsr printEntry
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("- press space -")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
  __b3:
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // while(keyboard_key_pressed(KEY_SPACE)==0)
    cmp #0
    beq __b3
    // print_cls()
    jsr print_cls
    // }
    rts
  .segment Data
    str: .text "** entry 1 **"
    .byte 0
    str1: .text "- press space -"
    .byte 0
    str2: .text "** entry 2 **"
    .byte 0
}
.segment Code
// Initialize keyboard reading by setting CIA#1 Data Direction Registers
keyboard_init: {
    // CIA1->PORT_A_DDR = $ff
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA1->PORT_B_DDR = $00
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR
    // }
    rts
}
// Perform binary multiplication of two unsigned 8-bit chars into a 16-bit unsigned int
// __zp(6) unsigned int mul8u(__register(X) char a, char b)
mul8u: {
    .label mb = 4
    .label res = 6
    .label return = 6
    lda #<SIZEOF_ENTRY
    sta.z mb
    lda #>SIZEOF_ENTRY
    sta.z mb+1
    lda #<0
    sta.z res
    sta.z res+1
  __b1:
    // while(a!=0)
    cpx #0
    bne __b2
    // }
    rts
  __b2:
    // a&1
    txa
    and #1
    // if( (a&1) != 0)
    cmp #0
    beq __b3
    // res = res + mb
    clc
    lda.z res
    adc.z mb
    sta.z res
    lda.z res+1
    adc.z mb+1
    sta.z res+1
  __b3:
    // a = a>>1
    txa
    lsr
    tax
    // mb = mb<<1
    asl.z mb
    rol.z mb+1
    jmp __b1
}
// Set all values in the passed struct
// Sets the values to n, n+1, n... to help test that everything works as intended
// void initEntry(__zp(4) char *entry, __register(X) char n)
initEntry: {
    .label __1 = 8
    .label __3 = $a
    .label __5 = 2
    .label __7 = $e
    .label __17 = $c
    .label entry = 4
    // 0x1111+n
    txa
    clc
    adc #<$1111
    sta.z __1
    lda #>$1111
    adc #0
    sta.z __1+1
    // *entryBufDisk(entry) = (byte*)(0x1111+n)
    ldy #0
    lda.z __1
    sta (entry),y
    iny
    lda.z __1+1
    sta (entry),y
    // 0x2222+n
    txa
    clc
    adc #<$2222
    sta.z __3
    lda #>$2222
    adc #0
    sta.z __3+1
    // *entryBufEdit(entry) = (byte*)(0x2222+n)
    ldy #2
    lda.z __3
    sta (entry),y
    iny
    lda.z __3+1
    sta (entry),y
    // 0x3333+n
    txa
    clc
    adc #<$3333
    sta.z __5
    lda #>$3333
    adc #0
    sta.z __5+1
    // *entryTsLen(entry) = 0x3333+n
    ldy #4
    lda.z __5
    sta (entry),y
    iny
    lda.z __5+1
    sta (entry),y
    // 0x4444+n
    txa
    clc
    adc #<$4444
    sta.z __7
    lda #>$4444
    adc #0
    sta.z __7+1
    // *entryTsOrder(entry) = (word*)(0x4444+n)
    ldy #6
    lda.z __7
    sta (entry),y
    iny
    lda.z __7+1
    sta (entry),y
    // 0x55+n
    txa
    clc
    adc #$55
    // *entryTLastLink(entry) = 0x55+n
    ldy #8
    sta (entry),y
    // 0x66+n
    txa
    clc
    adc #$66
    // *entrySLastLink(entry) = 0x66+n
    ldy #9
    sta (entry),y
    // 0x77+n
    txa
    clc
    adc #$77
    // *entryBFlag(entry) = 0x77+n
    ldy #$a
    sta (entry),y
    // 0x88+n
    txa
    clc
    adc #$88
    // *entryBError(entry) = 0x88+n
    ldy #$b
    sta (entry),y
    // 0x9999+n
    txa
    clc
    adc #<$9999
    sta.z __17
    lda #>$9999
    adc #0
    sta.z __17+1
    // *entryUCross(entry) = 0x9999+n
    ldy #$c
    lda.z __17
    sta (entry),y
    iny
    lda.z __17+1
    sta (entry),y
    // 0xaa+n
    txa
    clc
    adc #$aa
    // *entryBAddrLo(entry) = 0xaa+n
    ldy #$e
    sta (entry),y
    // 0xbb+n
    txa
    clc
    adc #$bb
    // *entryBAddrHi(entry) = 0xbb+n
    ldy #$f
    sta (entry),y
    // 0xcc+n
    txa
    clc
    adc #$cc
    // *entryTHi(entry) = 0xcc+n
    ldy #$10
    sta (entry),y
    // 0xdd+n
    txa
    clc
    adc #$dd
    // *entryTLo(entry) = 0xdd+n
    ldy #$11
    sta (entry),y
    // }
    rts
}
// Clear the screen. Also resets current line/char cursor.
print_cls: {
    // memset(print_screen, ' ', 1000)
    jsr memset
    // }
    rts
}
// Print a zero-terminated string
// void print_str(__zp(4) char *str)
print_str: {
    .label str = 4
  __b1:
    // while(*str)
    ldy #0
    lda (str),y
    cmp #0
    bne __b2
    // }
    rts
  __b2:
    // print_char(*(str++))
    ldy #0
    lda (str),y
    jsr print_char
    // print_char(*(str++));
    inc.z str
    bne !+
    inc.z str+1
  !:
    jmp __b1
}
// Print a newline
print_ln: {
  __b1:
    // print_line_cursor + $28
    lda #$28
    clc
    adc.z print_line_cursor_1
    sta.z print_line_cursor
    lda #0
    adc.z print_line_cursor_1+1
    sta.z print_line_cursor+1
    // while (print_line_cursor<print_char_cursor)
    cmp.z print_char_cursor+1
    bcc __b2
    bne !+
    lda.z print_line_cursor
    cmp.z print_char_cursor
    bcc __b2
  !:
    // }
    rts
  __b2:
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    jmp __b1
}
// Print the contents of a file entry
// void printEntry(__zp($10) char *entry)
printEntry: {
    .label entry = $10
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("bufdisk   ")
    lda #<str
    sta.z print_str.str
    lda #>str
    sta.z print_str.str+1
    jsr print_str
    ldy #0
    lda (entry),y
    sta.z print_uint.w
    iny
    lda (entry),y
    sta.z print_uint.w+1
    // print_uint((word)*entryBufDisk(entry))
    jsr print_uint
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("bufedit   ")
    lda #<str1
    sta.z print_str.str
    lda #>str1
    sta.z print_str.str+1
    jsr print_str
    ldy #2
    lda (entry),y
    sta.z print_uint.w
    iny
    lda (entry),y
    sta.z print_uint.w+1
    // print_uint((word)*entryBufEdit(entry))
    jsr print_uint
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("tslen     ")
    lda #<str2
    sta.z print_str.str
    lda #>str2
    sta.z print_str.str+1
    jsr print_str
    // print_uint(*entryTsLen(entry))
    ldy #4
    lda (entry),y
    sta.z print_uint.w
    iny
    lda (entry),y
    sta.z print_uint.w+1
    jsr print_uint
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("tsorder   ")
    lda #<str3
    sta.z print_str.str
    lda #>str3
    sta.z print_str.str+1
    jsr print_str
    ldy #6
    lda (entry),y
    sta.z print_uint.w
    iny
    lda (entry),y
    sta.z print_uint.w+1
    // print_uint((word)*entryTsOrder(entry))
    jsr print_uint
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("tlastlink   ")
    lda #<str4
    sta.z print_str.str
    lda #>str4
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryTLastLink(entry))
    ldy #8
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("slastlink   ")
    lda #<str5
    sta.z print_str.str
    lda #>str5
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entrySLastLink(entry))
    ldy #9
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("bflag       ")
    lda #<str6
    sta.z print_str.str
    lda #>str6
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryBFlag(entry))
    ldy #$a
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("berror      ")
    lda #<str7
    sta.z print_str.str
    lda #>str7
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryBError(entry))
    ldy #$b
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("ucross    ")
    lda #<str8
    sta.z print_str.str
    lda #>str8
    sta.z print_str.str+1
    jsr print_str
    // print_uint(*entryUCross(entry))
    ldy #$c
    lda (entry),y
    sta.z print_uint.w
    iny
    lda (entry),y
    sta.z print_uint.w+1
    jsr print_uint
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("baddrlo     ")
    lda #<str9
    sta.z print_str.str
    lda #>str9
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryBAddrLo(entry))
    ldy #$e
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("baddrhi     ")
    lda #<str10
    sta.z print_str.str
    lda #>str10
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryBAddrHi(entry))
    ldy #$f
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("thi         ")
    lda #<str11
    sta.z print_str.str
    lda #>str11
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryTHi(entry))
    ldy #$10
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    lda.z print_line_cursor
    sta.z print_char_cursor
    lda.z print_line_cursor+1
    sta.z print_char_cursor+1
    // print_str("tlo         ")
    lda #<str12
    sta.z print_str.str
    lda #>str12
    sta.z print_str.str+1
    jsr print_str
    // print_uchar(*entryTLo(entry))
    ldy #$11
    lda (entry),y
    tax
    jsr print_uchar
    lda.z print_line_cursor
    sta.z print_line_cursor_1
    lda.z print_line_cursor+1
    sta.z print_line_cursor_1+1
    // print_ln()
    jsr print_ln
    // }
    rts
  .segment Data
    str: .text "bufdisk   "
    .byte 0
    str1: .text "bufedit   "
    .byte 0
    str2: .text "tslen     "
    .byte 0
    str3: .text "tsorder   "
    .byte 0
    str4: .text "tlastlink   "
    .byte 0
    str5: .text "slastlink   "
    .byte 0
    str6: .text "bflag       "
    .byte 0
    str7: .text "berror      "
    .byte 0
    str8: .text "ucross    "
    .byte 0
    str9: .text "baddrlo     "
    .byte 0
    str10: .text "baddrhi     "
    .byte 0
    str11: .text "thi         "
    .byte 0
    str12: .text "tlo         "
    .byte 0
}
.segment Code
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// __register(A) char keyboard_key_pressed(char key)
keyboard_key_pressed: {
    .const colidx = KEY_SPACE&7
    .label rowidx = KEY_SPACE>>3
    // keyboard_matrix_read(rowidx)
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    and keyboard_matrix_col_bitmask+colidx
    // }
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// void * memset(void *str, char c, unsigned int num)
memset: {
    .const c = ' '
    .const num = $3e8
    .label str = print_screen
    .label end = str+num
    .label dst = 2
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
// Print a single char
// void print_char(__register(A) char ch)
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
// Print a unsigned int as HEX
// void print_uint(__zp(8) unsigned int w)
print_uint: {
    .label w = 8
    // print_uchar(BYTE1(w))
    ldx.z w+1
    jsr print_uchar
    // print_uchar(BYTE0(w))
    ldx.z w
    jsr print_uchar
    // }
    rts
}
// Print a char as HEX
// void print_uchar(__register(X) char b)
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
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// __register(A) char keyboard_matrix_read(char rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask+keyboard_key_pressed.rowidx
    sta CIA1
    // char row_pressed_bits = ~CIA1->PORT_B
    lda CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B
    eor #$ff
    // }
    rts
}
.segment Data
  print_hextab: .text "0123456789abcdef"
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
  // All files
  files: .fill MAX_FILES*SIZEOF_ENTRY, 0
