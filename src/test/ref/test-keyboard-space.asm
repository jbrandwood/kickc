// Test keyboard input - test the space bar
/// @file
/// Simple Keyboard Input Library
///
/// C64 Keyboard Matrix Reference - from http://codebase64.org/doku.php?id=base:reading_the_keyboard
/// Keyboard Codes are %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
/// +----+----------------------+-------------------------------------------------------------------------------------------------------+
/// |    | Write                |                                Read $dc01 (C64 screen code in parenthesis):                              |
/// |row:| $dc00: row bits      +------------+------------+------------+------------+------------+------------+------------+------------+
/// |    |                      |   BIT 7    |   BIT 6    |   BIT 5    |   BIT 4    |   BIT 3    |   BIT 2    |   BIT 1    |   BIT 0    |
/// +----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
/// |0.  | #%11111110 (254/$fe) | DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
/// |1.  | #%11111101 (253/$fd) |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
/// |2.  | #%11111011 (251/$fb) |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
/// |3.  | #%11110111 (247/$f7) |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
/// |4.  | #%11101111 (239/$ef) |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
/// |5.  | #%11011111 (223/$df) |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
/// |6.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
/// |7.  | #%01111111 (127/$7f) | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
/// +----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
  // Commodore 64 PRG executable file
.file [name="test-keyboard-space.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const KEY_SPACE = $3c
  .const GREEN = 5
  .const BLUE = 6
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR = 2
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR = 3
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  /// $D012 RASTER Raster counter
  .label RASTER = $d012
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
.segment Code
main: {
    // keyboard_init()
    jsr keyboard_init
  __b1:
    // while (*RASTER!=$ff)
    lda #$ff
    cmp RASTER
    bne __b1
    // keyboard_key_pressed(KEY_SPACE)
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE)!=0)
    cmp #0
    bne __b4
    // *BG_COLOR = BLUE
    lda #BLUE
    sta BG_COLOR
    jmp __b1
  __b4:
    // *BG_COLOR = GREEN
    lda #GREEN
    sta BG_COLOR
    jmp __b1
}
// Initialize keyboard reading by setting CIA#1 Data Direction Registers
keyboard_init: {
    // CIA1->PORT_A_DDR = 0xff
    // Keyboard Matrix Columns Write Mode
    lda #$ff
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_A_DDR
    // CIA1->PORT_B_DDR = 0x00
    // Keyboard Matrix Columns Read Mode
    lda #0
    sta CIA1+OFFSET_STRUCT_MOS6526_CIA_PORT_B_DDR
    // }
    rts
}
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
  // Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
  keyboard_matrix_row_bitmask: .byte $fe, $fd, $fb, $f7, $ef, $df, $bf, $7f
  // Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
  keyboard_matrix_col_bitmask: .byte 1, 2, 4, 8, $10, $20, $40, $80
