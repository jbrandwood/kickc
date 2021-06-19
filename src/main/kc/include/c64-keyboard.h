/// @file
/// Simple Keyboard Input Library
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

/// Keyboard Codes for all 63 keys.
/// Keyboard Codes are %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7).
/// See C64 Keyboard Matrix Reference http://codebase64.org/doku.php?id=base:reading_the_keyboard
const char KEY_DEL          = $00;
const char KEY_RETURN       = $01;
const char KEY_CRSR_RIGHT   = $02;
const char KEY_F7           = $03;
const char KEY_F1           = $04;
const char KEY_F3           = $05;
const char KEY_F5           = $06;
const char KEY_CRSR_DOWN    = $07;
const char KEY_3            = $08;
const char KEY_W            = $09;
const char KEY_A            = $0a;
const char KEY_4            = $0b;
const char KEY_Z            = $0c;
const char KEY_S            = $0d;
const char KEY_E            = $0e;
const char KEY_LSHIFT       = $0f;
const char KEY_5            = $10;
const char KEY_R            = $11;
const char KEY_D            = $12;
const char KEY_6            = $13;
const char KEY_C            = $14;
const char KEY_F            = $15;
const char KEY_T            = $16;
const char KEY_X            = $17;
const char KEY_7            = $18;
const char KEY_Y            = $19;
const char KEY_G            = $1a;
const char KEY_8            = $1b;
const char KEY_B            = $1c;
const char KEY_H            = $1d;
const char KEY_U            = $1e;
const char KEY_V            = $1f;
const char KEY_9            = $20;
const char KEY_I            = $21;
const char KEY_J            = $22;
const char KEY_0            = $23;
const char KEY_M            = $24;
const char KEY_K            = $25;
const char KEY_O            = $26;
const char KEY_N            = $27;
const char KEY_PLUS         = $28;
const char KEY_P            = $29;
const char KEY_L            = $2a;
const char KEY_MINUS        = $2b;
const char KEY_DOT          = $2c;
const char KEY_COLON        = $2d;
const char KEY_AT           = $2e;
const char KEY_COMMA        = $2f;
const char KEY_POUND        = $30;
const char KEY_ASTERISK     = $31;
const char KEY_SEMICOLON    = $32;
const char KEY_HOME         = $33;
const char KEY_RSHIFT       = $34;
const char KEY_EQUALS       = $35;
const char KEY_ARROW_UP     = $36;
const char KEY_SLASH        = $37;
const char KEY_1            = $38;
const char KEY_ARROW_LEFT   = $39;
const char KEY_CTRL         = $3a;
const char KEY_2            = $3b;
const char KEY_SPACE        = $3c;
const char KEY_COMMODORE    = $3d;
const char KEY_Q            = $3e;
const char KEY_RUNSTOP      = $3f;

/// Initialize keyboard reading by setting CIA#$ Data Direction Registers
void keyboard_init();

/// Check if any key is currently pressed on the keyboard matrix
/// Return 0 if no key is pressed and not 0 if any key is pressed
char keyboard_matrix_any(void);

/// Read a single row of the keyboard matrix
/// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
/// Returns the keys pressed on the row as bits according to the C64 key matrix.
/// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
/// leading to erroneous readings. You must disable kill the normal interrupt or sei/cli around calls to the keyboard matrix reader.
char keyboard_matrix_read(char rowid);

/// Determines whether a specific key is currently pressed by accessing the matrix directly
/// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
/// All keys exist as as KEY_XXX constants.
/// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
char keyboard_key_pressed(char key);

/// Get the keycode corresponding to a specific screen code character
/// ch is the character to get the key code for ($00-$3f)
/// Returns the key code corresponding to the passed character. Only characters with a non-shifted key are handled.
/// If there is no non-shifted key representing the char $3f is returned (representing RUN/STOP) .
char keyboard_get_keycode(char ch);

/// Current keyboard modifiers (left shift, right shift, ctrl, commodore)
extern char keyboard_modifiers;
/// Left shift is pressed
extern const char KEY_MODIFIER_LSHIFT;
/// Right shift is pressed
extern const char KEY_MODIFIER_RSHIFT;
/// CTRL is pressed
extern const char KEY_MODIFIER_CTRL;
/// Commodore is pressed
extern const char KEY_MODIFIER_COMMODORE;
/// Any shift is pressed
extern const char KEY_MODIFIER_SHIFT;

/// Scans the entire matrix to determine which keys have been pressed/depressed.
/// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
/// Handles debounce and only generates events when the status of a key changes.
/// Also stores current status of modifiers in keyboard_modifiers.
void keyboard_event_scan();

/// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
/// Returns 0 is not pressed and non-0 if pressed
char keyboard_event_pressed(char keycode);

/// Get the next event from the keyboard event buffer.
/// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
/// The buffer is filled by keyboard_event_scan()
char keyboard_event_get();

