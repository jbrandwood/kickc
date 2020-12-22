// Pre-calculated bobs inside a charset (pre-moved to all x/y-combinations)
#include <c64.h>
#include <string.h>
#include <keyboard.h>
#include <time.h>
#include <print.h>
#include <fastmultiply.h>

// The prototype BOB (a 3x3 char image with a bob image in the upper 2x2 chars)
// The chars are layout as follows with data in chars 0, 1, 3, 4 initially
//   0 3 6
//   1 4 7
//   2 5 8
const char PROTO_BOB[3*3*8] = kickasm(resource "smiley.png") {{
	.var pic = LoadPicture("smiley.png", List().add($000000, $ffffff))
	.for (var x=0;x<3; x++)
    	.for (var y=0; y<24; y++)
            .byte pic.getSinglecolorByte(x,y)
}};

// Sine and Cosine tables
// Angles: $00=0, $80=PI,$100=2*PI
// Sine/Cosine: signed fixed [-$7f,$7f]
signed char __align(0x40) SIN[0x140] = kickasm {{
    .for(var i=0;i<$140;i++)
        .byte >round($7fff*sin(i*2*PI/256))
}};

signed char* COS = SIN+$40; // sin(x) = cos(x+PI/2)

// Vogel Sunflower polar coordinates
__align(0x100) const char VOGEL_THETA[] = kickasm {{
    .const PHI = (1+sqrt(5))/2
    .fill 100, round(mod(256*i/(PHI*PHI),256))
}};
__align(0x100) const char VOGEL_R[] = kickasm {{ .fill 100, round(sqrt(i)*15) }};

// The BASIC screen
char* const SCREEN_BASIC = 0x0400;
// The BASIC charset
char* const CHARSET_BASIC = 0x1000;
// The BOB screen
char* const BOB_SCREEN = 0x2800;
// The BOB charset
char* const BOB_CHARSET = 0x2000;

// Tables containing the char to use for a specific cell of a shifted BOB.
// char_id = BOB_TABLES[cell*BOB_SUBTABLE_SIZE + shift_y*BOB_SHIFTS_X + shift_x];
char BOB_TABLES[9*8*4];
// The number of different X-shifts
const char BOB_SHIFTS_X = 4;
// The number of different Y-shifts
const char BOB_SHIFTS_Y = 8;
// The size of a sub-table of BOB_TABLES
const char BOB_SUBTABLE_SIZE =  BOB_SHIFTS_X*BOB_SHIFTS_Y;

// The number of BOBs to render
const char NUM_BOBS = 20;

void main() {
    mulf_init();
	prepareBobs();
	renderBobInit();
	vicSelectGfxBank(BOB_SCREEN);
	*D018 = toD018(BOB_SCREEN, BOB_CHARSET);
	/*
	// Clear screen
	memset(BOB_SCREEN, 0x00, 1000);
	// Display a BOB grid
	for(char x: 0..7)
	    for(char y: 0..3)
            renderBob(x*12+y, y*24+x);
	// Wait for space
	while(!keyboard_key_pressed(KEY_SPACE)) {}
	while(keyboard_key_pressed(KEY_SPACE)) {}
	*/
	// Clear screen
	memset(BOB_SCREEN, 0x00, 1000);
	// Render Rotated BOBs
	char angle = 0;
	while(true) {
        do { } while (*RASTER<$f8);
        *BORDER_COLOR = 0xf;
        renderBobCleanup();
	    signed char r = 30;
        char a = angle;
        for(char i: 0..NUM_BOBS-1) {
            //kickasm {{ .break }}
            *BORDER_COLOR = 1;
            int x = mulf8s(r, COS[a]) + 75*0x100;
            int y = mulf8s(r, SIN[a])*2 + 90*0x100;
            *BORDER_COLOR = 2;
            a += 98;
            r += 3;
            renderBob(>x, >y);
        }
        angle += 3;
        *BORDER_COLOR = 0;
	    if(keyboard_key_pressed(KEY_SPACE)) {
	        break;
	    }
	}
	// Wait for space release
	while(keyboard_key_pressed(KEY_SPACE)) {}
	// Return to BASIC
	vicSelectGfxBank(SCREEN_BASIC);
	*D018 = toD018(SCREEN_BASIC, CHARSET_BASIC);
}

// Table used for deleting rendered BOB's. Contains pointers to first char of each BOB.
char* RENDERBOB_CLEANUP[NUM_BOBS];

// Pointer to the next clean-up to add
char** renderBobCleanupNext;

// *40 Table unsigned int[0x20] MUL40 = { ((unsigned int)i)*40 };
unsigned int MUL40[0x20];

// Initialize the tables used by renderBob()
void renderBobInit() {
    for(char y: 0..0x1f)
        MUL40[y] = ((unsigned int)y)*40;
    for(char i: 0..NUM_BOBS-1)
        RENDERBOB_CLEANUP[i] = BOB_SCREEN;
}

// Render a single BOB at a given x/y-position
// X-position is 0-151. Each x-position is 2 pixels wide.
// Y-position is 0-183. Each y-position is 1 pixel high.
void renderBob(char xpos, char ypos) {
	char x_char_offset = xpos/BOB_SHIFTS_X;
	char y_char_offset = ypos/BOB_SHIFTS_Y;
	unsigned int y_offset = MUL40[y_char_offset];
	char* screen = BOB_SCREEN+y_offset+x_char_offset;
	char bob_table_idx = (ypos&7)*BOB_SHIFTS_X+(xpos&3);
	*renderBobCleanupNext++ = screen;
    screen[0]  = (BOB_TABLES+0*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[40] = (BOB_TABLES+1*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[80] = (BOB_TABLES+2*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[1]  = (BOB_TABLES+3*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[41] = (BOB_TABLES+4*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[81] = (BOB_TABLES+5*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[2]  = (BOB_TABLES+6*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[42] = (BOB_TABLES+7*BOB_SUBTABLE_SIZE)[bob_table_idx];
    screen[82] = (BOB_TABLES+8*BOB_SUBTABLE_SIZE)[bob_table_idx];
}

// Clean Up the rendered BOB's
void renderBobCleanup() {
    for(char i: 0..NUM_BOBS-1) {
        char* screen = RENDERBOB_CLEANUP[i];
        screen[0]  = 0;
        screen[40]  = 0;
        screen[80]  = 0;
        screen[1]  = 0;
        screen[41]  = 0;
        screen[81]  = 0;
        screen[2]  = 0;
        screen[42]  = 0;
        screen[82]  = 0;
    }
    // Prepare for next clean-up
    renderBobCleanupNext = RENDERBOB_CLEANUP;
}

// Creates the pre-shifted bobs into BOB_CHARSET and populates the BOB_TABLES
// Modifies PROTO_BOB by shifting it around
void prepareBobs() {
    progress_init(SCREEN_BASIC);
	bob_charset_next_id = 0;
    // Ensure that glyph #0 is empty
    bobCharsetFindOrAddGlyph(PROTO_BOB+48);
	char bob_table_idx = 0;
	for(char shift_y=0;shift_y<BOB_SHIFTS_Y;shift_y++) {
		for(char shift_x=0;shift_x<BOB_SHIFTS_X;shift_x++) {
			// Populate charset and tables
			char* bob_glyph = PROTO_BOB;
			char* bob_table = BOB_TABLES + bob_table_idx;
			for(char cell = 0; cell<9; cell++) {
				// Look for an existing char in BOB_CHARSET 
				*bob_table = bobCharsetFindOrAddGlyph(bob_glyph);
				// Move to the next glyph
				bob_glyph+=8;
				// Move to the next sub-table
				bob_table += BOB_SHIFTS_X*BOB_SHIFTS_Y;
    			progress_inc();
			}
			// Move to the next bob table idx
			bob_table_idx++;
			// Shift PROTO_BOB right twice
			shiftProtoBobRight();
			shiftProtoBobRight();
		}
        // Shift PROTO_BOB down and 8px left
		shiftProtoBobDown();
	}
}


// Shift PROTO_BOB right one X pixel
void shiftProtoBobRight() {
	char carry = 0;
	char j = 0;
	for(char i=0;i<3*3*8;i++) {
		// Get the new carry (0x80 / 0x00)
		char new_carry = (PROTO_BOB[j]&1)?0x80ub:0ub;
		// Shift value and add old carry
		PROTO_BOB[j] = carry | PROTO_BOB[j]>>1;
		// Update carry
		carry = new_carry;
		// Increment j to iterate over the PROTO_BOB left-to-right, top-to-bottom (0, 24, 48, 1, 25, 49, ...)
		if(j>=48) {
			j-=47;
		} else {
			j+=24;
		}
	}
}

// Shift PROTO_BOB down one Y pixel
// At the same time restore PROTO_BOB X by shifting 8 pixels left
void shiftProtoBobDown() {
	for(char i=23;i>0;i--) {
		PROTO_BOB[i] = (PROTO_BOB+23)[i];
		(PROTO_BOB+24)[i] = (PROTO_BOB+47)[i];
		(PROTO_BOB+48)[i] = 0x00;
	}
	PROTO_BOB[0] = 0;
	PROTO_BOB[24] = 0;
	PROTO_BOB[48] = 0;
}

// BOB charset ID of the next glyph to be added
char bob_charset_next_id;

// Looks through BOB_CHARSET to find the passed bob glyph if present.
// If not present it is added
// Returns the glyph ID
char bobCharsetFindOrAddGlyph(char* bob_glyph) {
	char* glyph_cursor = BOB_CHARSET;
	char glyph_id = 0;
	while(glyph_id!=bob_charset_next_id) {
		char found = 1;
		for(char i=0;i<8;i++) {
			if(glyph_cursor[i]!=bob_glyph[i]) {
				found = 0;
				break;
			}
		}
		if(found) return glyph_id;
		glyph_id++;		
		glyph_cursor +=8;
	}
	// Not found - add it
	for(char i=0;i<8;i++)
		glyph_cursor[i]=bob_glyph[i];	
	bob_charset_next_id++;
	return glyph_id;
}

// Current position of the progress cursor
char* progress_cursor;
// Current index within the progress cursor (0-7)
char progress_idx;

// Initialize the PETSCII progress bar
void progress_init(char* line) {
    progress_cursor = line;
    progress_idx = 0;
}

// Increase PETSCII progress one bit
// Done by increasing the character until the idx is 8 and then moving to the next char
void progress_inc() {
    // Progress characters
    const char progress_chars[] = { 0x20, 0x65, 0x74, 0x75, 0x61, 0xf6, 0xe7, 0xea, 0xe0 };
    if(++progress_idx==8) {
        *progress_cursor = progress_chars[8];
        progress_cursor++;
        progress_idx = 0;
    }
    *progress_cursor = progress_chars[progress_idx];
}

