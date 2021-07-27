// Exploring keyboard glitch that finds "C" press when pressing space
// The glitch is caused by the "normal" C64 interrupt occuring just as the keyboard is read.
// Press "I" to disable interrupts (red border)
// Press "E" to enable interrupts (green border)
// Press "C" to enter pressed state (increaded BG_COLOR) - and "SPACE" to leave presssed state again.
// Holding SPACE will sometimes trigger the pressed state when normal interrupts are enabled (green border)
// but never when they are disabled (red border)
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
.file [name="keyboard-glitch.prg", type="prg", segments="Program"]
.segmentdef Program [segments="Basic, Code, Data"]
.segmentdef Basic [start=$0801]
.segmentdef Code [start=$80d]
.segmentdef Data [startAfter="Code"]
.segment Basic
:BasicUpstart(main)
  .const KEY_E = $e
  .const KEY_C = $14
  .const KEY_I = $21
  .const KEY_SPACE = $3c
  .const RED = 2
  .const GREEN = 5
  .const OFFSET_STRUCT_MOS6526_CIA_PORT_B = 1
  /// $D020 Border Color
  .label BORDER_COLOR = $d020
  /// $D021 Background Color 0
  .label BG_COLOR = $d021
  /// The CIA#1: keyboard matrix, joystick #1/#2
  .label CIA1 = $dc00
  .label SCREEN = $400
.segment Code
main: {
    // *BORDER_COLOR = GREEN
    lda #GREEN
    sta BORDER_COLOR
  __b1:
    // menu()
    jsr menu
    jmp __b1
}
menu: {
  __b1:
    // keyboard_key_pressed(KEY_C)
    ldx #KEY_C
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_C)
    // if(keyboard_key_pressed(KEY_C)!=0)
    cmp #0
    beq __b2
    // pressed()
    jsr pressed
    // }
    rts
  __b2:
    // keyboard_key_pressed(KEY_I)
    ldx #KEY_I
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_I)
    // if(keyboard_key_pressed(KEY_I)!=0)
    cmp #0
    beq __b3
    // *BORDER_COLOR = RED
    lda #RED
    sta BORDER_COLOR
    // asm
    sei
    rts
  __b3:
    // keyboard_key_pressed(KEY_E)
    ldx #KEY_E
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_E)
    // if(keyboard_key_pressed(KEY_E)!=0)
    cmp #0
    beq __b4
    // *BORDER_COLOR = GREEN
    lda #GREEN
    sta BORDER_COLOR
    // asm
    cli
    rts
  __b4:
    // (*SCREEN)++;
    inc SCREEN
    jmp __b1
}
// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
// keyboard_key_pressed(byte register(X) key)
keyboard_key_pressed: {
    // char colidx = key&7
    txa
    and #7
    tay
    // char rowidx = key>>3
    txa
    lsr
    lsr
    lsr
    // keyboard_matrix_read(rowidx)
    tax
    jsr keyboard_matrix_read
    // keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx]
    and keyboard_matrix_col_bitmask,y
    // }
    rts
}
pressed: {
    // (*BG_COLOR)++;
    inc BG_COLOR
  __b1:
    // keyboard_key_pressed(KEY_SPACE)
    ldx #KEY_SPACE
    jsr keyboard_key_pressed
    // keyboard_key_pressed(KEY_SPACE)
    // if(keyboard_key_pressed(KEY_SPACE)!=0)
    cmp #0
    bne __breturn
    jmp __b1
  __breturn:
    // }
    rts
}
// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
// keyboard_matrix_read(byte register(X) rowid)
keyboard_matrix_read: {
    // CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid]
    lda keyboard_matrix_row_bitmask,x
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
