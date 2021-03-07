// Simple Keyboard Input Library
// C64 Keyboard Matrix Reference - from http://codebase64.org/doku.php?id=base:reading_the_keyboard
// Keyboard Codes are %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// +----+----------------------+-------------------------------------------------------------------------------------------------------+
// |    | Write                |                                Read $dc01 (C64 screen code in parenthesis):                              |
// |row:| $dc00: row bits      +------------+------------+------------+------------+------------+------------+------------+------------+
// |    |                      |   BIT 7    |   BIT 6    |   BIT 5    |   BIT 4    |   BIT 3    |   BIT 2    |   BIT 1    |   BIT 0    |
// +----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+
// |0.  | #%11111110 (254/$fe) | DOWN  ($  )|   F5  ($  )|   F3  ($  )|   F1  ($  )|   F7  ($  )| RIGHT ($  )| RETURN($  )|DELETE ($  )|
// |1.  | #%11111101 (253/$fd) |LEFT-SH($  )|   e   ($05)|   s   ($13)|   z   ($1a)|   4   ($34)|   a   ($01)|   w   ($17)|   3   ($33)|
// |2.  | #%11111011 (251/$fb) |   x   ($18)|   t   ($14)|   f   ($06)|   c   ($03)|   6   ($36)|   d   ($04)|   r   ($12)|   5   ($35)|
// |3.  | #%11110111 (247/$f7) |   v   ($16)|   u   ($15)|   h   ($08)|   b   ($02)|   8   ($38)|   g   ($07)|   y   ($19)|   7   ($37)|
// |4.  | #%11101111 (239/$ef) |   n   ($0e)|   o   ($0f)|   k   ($0b)|   m   ($0d)|   0   ($30)|   j   ($0a)|   i   ($09)|   9   ($39)|
// |5.  | #%11011111 (223/$df) |   ,   ($2c)|   @   ($00)|   :   ($3a)|   .   ($2e)|   -   ($2d)|   l   ($0c)|   p   ($10)|   +   ($2b)|
// |6.  | #%10111111 (191/$bf) |   /   ($2f)|   ^   ($1e)|   =   ($3d)|RGHT-SH($  )|  HOME ($  )|   ;   ($3b)|   *   ($2a)|   £   ($1c)|
// |7.  | #%01111111 (127/$7f) | STOP  ($  )|   q   ($11)|COMMODR($  )| SPACE ($20)|   2   ($32)|CONTROL($  )|  <-   ($1f)|   1   ($31)|
// +----+----------------------+------------+------------+------------+------------+------------+------------+------------+------------+

#include <c64.h>
#include <c64-keyboard.h>

// Keycodes for each screen code character from $00-$3f.
// Chars that do not have an unmodified keycode return $3f (representing RUN/STOP).
const char keyboard_char_keycodes[] = {
    /*@*/KEY_AT,    /*a*/KEY_A,   /*b*/KEY_B,        /*c*/KEY_C,         /*d*/KEY_D,     /*e*/KEY_E,      /*f*/KEY_F,        /*g*/KEY_G,
    /*h*/KEY_H,     /*i*/KEY_I,   /*j*/KEY_J,        /*k*/KEY_K,         /*l*/KEY_L,     /*m*/KEY_M,      /*n*/KEY_N,        /*o*/KEY_O,
    /*p*/KEY_P,     /*q*/KEY_Q,   /*r*/KEY_R,        /*s*/KEY_S,         /*t*/KEY_T,     /*u*/KEY_U,      /*v*/KEY_V,        /*w*/KEY_W,
    /*x*/KEY_X,     /*y*/KEY_Y,   /*z*/KEY_Z,        /*[*/$3f,           /*£*/KEY_POUND, /*]*/$3f,        /*^*/KEY_ARROW_UP, /*<-*/KEY_ARROW_LEFT,
    /* */KEY_SPACE, /*!*/$3f,     /*"*/$3f,          /*#*/$3f,           /*$*/$3f,       /*%*/$3f,        /*&*/$3f,          /*´*/$3f,
    /*(*/$3f,       /*)*/$3f,     /***/KEY_ASTERISK, /*+*/KEY_PLUS,      /*,*/KEY_COMMA, /*-*/KEY_MINUS,  /*.*/KEY_DOT,      /*/*/KEY_SLASH,
    /*0*/KEY_0,     /*1*/KEY_1,   /*2*/KEY_2,        /*3*/KEY_3,         /*4*/KEY_4,     /*5*/KEY_5,      /*6*/KEY_6,        /*7*/KEY_7,
    /*8*/KEY_8,     /*9*/KEY_9,   /*:*/KEY_COLON,    /*;*/KEY_SEMICOLON, /*<*/$3f,       /*=*/KEY_EQUALS, /*>*/$3f,          /*?*/$3f
};

// Keyboard row bitmask as expected by CIA#1 Port A when reading a specific keyboard matrix row (rows are numbered 0-7)
char keyboard_matrix_row_bitmask[8] = { %11111110, %11111101, %11111011, %11110111, %11101111, %11011111, %10111111, %01111111 };

// Keyboard matrix column bitmasks for a specific keybooard matrix column when reading the keyboard. (columns are numbered 0-7)
char keyboard_matrix_col_bitmask[8] = { %00000001, %00000010, %00000100, %00001000, %00010000, %00100000, %01000000, %10000000 };

// Initialize keyboard reading by setting CIA#1 Data Direction Registers
void keyboard_init() {
    // Keyboard Matrix Columns Write Mode
    CIA1->PORT_A_DDR = $ff;
    // Keyboard Matrix Columns Read Mode
    CIA1->PORT_B_DDR = $00;
}

// Check if any key is currently pressed on the keyboard matrix
// Return 0 if no key is pressed and not 0 if any key is pressed
char keyboard_matrix_any(void) {
    CIA1->PORT_A = 0;
    return ~CIA1->PORT_B;
}

// Read a single row of the keyboard matrix
// The row ID (0-7) of the keyboard matrix row to read. See the C64 key matrix for row IDs.
// Returns the keys pressed on the row as bits according to the C64 key matrix.
// Notice: If the C64 normal interrupt is still running it will occasionally interrupt right between the read & write
// leading to erroneous readings. You must disable the normal interrupt or sei/cli around calls to the keyboard matrix reader.
char keyboard_matrix_read(char rowid) {
    CIA1->PORT_A = keyboard_matrix_row_bitmask[rowid];
    char row_pressed_bits = ~CIA1->PORT_B;
    return row_pressed_bits;
}

// Determines whether a specific key is currently pressed by accessing the matrix directly
// The key is a keyboard code defined from the keyboard matrix by %00rrrccc, where rrr is the row ID (0-7) and ccc is the column ID (0-7)
// All keys exist as as KEY_XXX constants.
// Returns zero if the key is not pressed and a non-zero value if the key is currently pressed
char keyboard_key_pressed(char key) {
    char colidx = key&7;
    char rowidx = key>>3;
    return keyboard_matrix_read(rowidx) & keyboard_matrix_col_bitmask[colidx];
}

// Get the keycode corresponding to a specific screen code character
// ch is the character to get the key code for ($00-$3f)
// Returns the key code corresponding to the passed character. Only characters with a non-shifted key are handled.
// If there is no non-shifted key representing the char $3f is returned (representing RUN/STOP) .
char keyboard_get_keycode(char ch) {
    return keyboard_char_keycodes[ch];
}

// Keyboard event buffer. Contains keycodes for key presses/releases. Presses are represented by the keycode. Releases by keycode | $40. The buffer is filled by keyboard_scan()
char keyboard_events[8];
// Keyboard event buffer size. The number of events currently in the event buffer
char keyboard_events_size = 0;
// Current keyboard modifiers (left shift, right shift, ctrl, commodore)
char keyboard_modifiers = 0;
// Left shift is pressed
const char KEY_MODIFIER_LSHIFT = 1;
// Right shift is pressed
const char KEY_MODIFIER_RSHIFT = 2;
// CTRL is pressed
const char KEY_MODIFIER_CTRL = 4;
// Commodore is pressed
const char KEY_MODIFIER_COMMODORE = 8;
// Any shift is pressed
const char KEY_MODIFIER_SHIFT = KEY_MODIFIER_LSHIFT|KEY_MODIFIER_RSHIFT;
// The values scanned values for each row. Set by keyboard_scan() and used by keyboard_get_event()
char keyboard_scan_values[8];

// Scans the entire matrix to determine which keys have been pressed/depressed.
// Generates keyboard events into the event buffer. Events can be read using keyboard_event_get().
// Handles debounce and only generates events when the status of a key changes.
// Also stores current status of modifiers in keyboard_modifiers.
void keyboard_event_scan() {
    char keycode = 0;
    for(char row : 0..7) {
        char row_scan = keyboard_matrix_read(row);
        if(row_scan!=keyboard_scan_values[row]) {
            // Something has changed on the keyboard row - check each column
            for(char col : 0..7){
                // XOR of row scan with the last seen row scan AND'ed with the col bitmask will be non-0 if the key status is changed
                if(((row_scan^keyboard_scan_values[row])&keyboard_matrix_col_bitmask[col])!=0) {
                    // Key(row, col) status has changed. We have an event.
                    // Only process event if there is still room in the buffer
                    if(keyboard_events_size!=8) {
                        // AND of row scan and bit mask determines if key is pressed or released
                        char event_type = row_scan&keyboard_matrix_col_bitmask[col];
                        if(event_type==0) {
                            // Key released
                            keyboard_events[keyboard_events_size++] = keycode|$40;
                        } else {
                            // Key pressed
                            keyboard_events[keyboard_events_size++] = keycode;
                        }
                    }
                }
                keycode++;
            }
            // Store the current keyboard status for the row to debounce
            keyboard_scan_values[row] = row_scan;
        } else {
            // Update current keycode
            keycode = keycode + 8;
        }
    }
    // Update the keyboard modifiers
    keyboard_modifiers = 0;
    if(keyboard_event_pressed(KEY_LSHIFT)!= 0) {
        keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_LSHIFT;
    }
    if(keyboard_event_pressed(KEY_RSHIFT)!= 0) {
        keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_RSHIFT;
    }
    if(keyboard_event_pressed(KEY_CTRL)!= 0) {
        keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_CTRL;
    }
    if(keyboard_event_pressed(KEY_COMMODORE)!= 0) {
        keyboard_modifiers = keyboard_modifiers | KEY_MODIFIER_COMMODORE;
    }
}

// Determine if a specific key is currently pressed based on the last keyboard_event_scan()
// Returns 0 is not pressed and non-0 if pressed
char keyboard_event_pressed(char keycode) {
    char row_bits = keyboard_scan_values[keycode>>3];
    return row_bits & keyboard_matrix_col_bitmask[keycode&7];
}

// Get the next event from the keyboard event buffer.
// Returns $ff if there is no event waiting. As all events are <$7f it is enough to examine bit 7 when determining if there is any event to process.
// The buffer is filled by keyboard_event_scan()
char keyboard_event_get() {
    if(keyboard_events_size==0) {
        return $ff;
    } else {
        return keyboard_events[--keyboard_events_size];
    }
}

