// Tetris Game for the Commodore 64
// All rendering logic for showing the playfield, the pieces and the scores
// Also handles double buffering

#include "tetris-data.c"
#include "tetris-pieces.c"

// Address of the original playscreen chars
const char PLAYFIELD_SCREEN_ORIGINAL_WIDTH=32;
const char PLAYFIELD_SCREEN_ORIGINAL[] = kickasm(resource "playfield-screen.iscr", resource "playfield-extended.col" ) {{
   // Load chars for the screen
  .var screen = LoadBinary("playfield-screen.iscr")
   // Load extended colors for the screen
  .var extended = LoadBinary("playfield-extended.col")
  // screen.get(i)+1 because the charset is loaded into PLAYFIELD_CHARSET+8
  // extended.get(i)-1 because the extended colors are 1-based (1/2/3/4)
  // <<6 to move extended colors to the upper 2 bits
  .fill screen.getSize(), ( (screen.get(i)+1) | (extended.get(i)-1)<<6 )
}};

// Original Color Data
const char PLAYFIELD_COLORS_ORIGINAL[] = kickasm(resource "playfield-screen.col") {{
  .import binary "playfield-screen.col"
}};

// The color #1 to use for the pieces for each level
char PIECES_COLORS_1[] = {
            BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED,
            BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED,
            BLUE, GREEN, PURPLE, BLUE, RED, LIGHT_GREEN, RED, BLUE, LIGHT_BLUE, RED
        };
// The color #2 to use for the pieces for each level
char PIECES_COLORS_2[] = {
            CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE,
            CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE,
            CYAN, LIGHT_GREEN, PINK, LIGHT_GREEN, LIGHT_GREEN, LIGHT_BLUE, DARK_GREY, PURPLE, RED, ORANGE
        };

// Pointers to the screen address for rendering each playfield line
// The lines for screen 1 is aligned with 0x80 and screen 2 with 0x40 - so XOR'ing with 0x40 gives screen 2 lines.
__align(0x80) char* screen_lines_1[PLAYFIELD_LINES];
__align(0x40) char* screen_lines_2[PLAYFIELD_LINES];

// Initialize rendering
void render_init() {
	vicSelectGfxBank(PLAYFIELD_CHARSET);
	// Enable Extended Background Color Mode
	*D011 = VICII_ECM | VICII_DEN | VICII_RSEL | 3;
	*BORDER_COLOR = BLACK;
	*BG_COLOR = BLACK;
	*BG_COLOR1 = PIECES_COLORS_1[0];
	*BG_COLOR2 = PIECES_COLORS_2[0];
	*BG_COLOR3 = GREY;

    // Setup chars on the screens
	render_screen_original(PLAYFIELD_SCREEN_1);
	render_screen_original(PLAYFIELD_SCREEN_2);

	// Initialize the screen line pointers;
	char* li_1 = PLAYFIELD_SCREEN_1 + 2*40 + 16;
	char* li_2 = PLAYFIELD_SCREEN_2 + 2*40 + 16;
	for(char i:0..PLAYFIELD_LINES-1) {
		screen_lines_1[i] = li_1;
		screen_lines_2[i] = li_2;
		li_1 += 40;
		li_2 += 40;
	}

    // Show showing screen 1 and rendering to screen 2
    render_screen_show = 0;
    render_screen_render = 0x20;
}

// Update 0xD018 to show the current screen (used for double buffering)
void render_show() {
    char d018val = 0;
    if(render_screen_show==0) {
        d018val = toD018(PLAYFIELD_SCREEN_1, PLAYFIELD_CHARSET);
    } else {
        d018val = toD018(PLAYFIELD_SCREEN_2, PLAYFIELD_CHARSET);
    }
	*D018 = d018val;
	*BG_COLOR1 = PIECES_COLORS_1[level];
	*BG_COLOR2 = PIECES_COLORS_2[level];
	render_screen_showing = render_screen_show;
}

// Swap rendering to the other screen (used for double buffering)
void render_screen_swap() {
    render_screen_render ^= 0x20;
    render_screen_show ^= 0x20;
}

// Show the current score
void render_score() {
    char* screen;
    if(render_screen_render==0) {
        screen = PLAYFIELD_SCREEN_1;
    } else {
        screen = PLAYFIELD_SCREEN_2;
    }

    char* score_bytes = (byte*)(&score_bcd);
    unsigned int score_offset = 40*0x05 + 0x1c;
    render_bcd( screen, score_offset, score_bytes[2], 0);
    render_bcd( screen, score_offset+2, score_bytes[1], 0);
    render_bcd( screen, score_offset+4, score_bytes[0], 0);

    unsigned int lines_offset = 40*0x01 + 0x16;
    render_bcd( screen, lines_offset, >lines_bcd, 1);
    render_bcd( screen, lines_offset+1, <lines_bcd, 0);

    unsigned int level_offset = 40*19 + 0x1f;
    render_bcd( screen, level_offset, level_bcd, 0);

}

// Render BCD digits on a screen.
// - screen: pointer to the screen to render on
// - offset: offset on the screen
// - bcd: The BCD-value to render
// - only_low: if non-zero only renders the low digit
void render_bcd(char* screen, unsigned int offset, char bcd, char only_low) {
    const char ZERO_CHAR = 53;
    char* screen_pos = screen+offset;
    if(only_low==0) {
        *screen_pos++ = ZERO_CHAR + (bcd >> 4);
    }
    *screen_pos++ = ZERO_CHAR + (bcd & 0x0f);
}

// Copy the original screen data to the passed screen
// Also copies colors to 0xd800
void render_screen_original(char* screen) {
    char SPACE = 0;
	char* oscr = PLAYFIELD_SCREEN_ORIGINAL+32*2;
	char* ocols = PLAYFIELD_COLORS_ORIGINAL+32*2;
	char* cols = COLS;
	for(char y:0..24) {
	    char x=0;
	    do {
	        *screen++ = SPACE;
	        *cols++ = BLACK;
	    } while(++x!=4);
	    do {
	        *screen++ = *oscr++;
	        *cols++ = *ocols++;
	    } while(++x!=36);
	    do {
	        *screen++ = SPACE;
	        *cols++ = BLACK;
	    } while(++x!=40);
	}
}

// Render the static playfield on the screen (all pieces already locked into place)
void render_playfield() {
	// Do not render the top 2 lines.
	char i = PLAYFIELD_COLS*2;
	for(char l:2..PLAYFIELD_LINES-1) {
		char* screen_line = screen_lines_1[render_screen_render+l];
		for(char c:0..PLAYFIELD_COLS-1) {
			*(screen_line++) = playfield[i++];
		}
	}
}

// Render the current moving piece at position (current_xpos, current_ypos)
// Ignores cases where parts of the tetromino is outside the playfield (sides/bottom) since the movement collision routine prevents this.
void render_moving() {
	char i = 0;
	char ypos = current_ypos;
	for(char l:0..3) {
		if(ypos>1) {
			char* screen_line = screen_lines_1[render_screen_render+ypos];
			char xpos = current_xpos;
			for(char c:0..3) {
				char current_cell = current_piece_gfx[i++];
				if(current_cell!=0) {
				    screen_line[xpos] = current_piece_char;
				}
				xpos++;
			}
		} else {
		    i += 4;
		}
		ypos++;
	}
}

// Render the next tetromino in the "next" area
void render_next() {
    // Find the screen area
	unsigned int next_area_offset = 40*12 + 24 + 4;
    char* screen_next_area;
    if(render_screen_render==0) {
        screen_next_area = PLAYFIELD_SCREEN_1+next_area_offset;
    } else {
        screen_next_area = PLAYFIELD_SCREEN_2+next_area_offset;
    }

    // Render the next piece
	char* next_piece_gfx = PIECES[next_piece_idx];
	char next_piece_char = PIECES_NEXT_CHARS[next_piece_idx];
	for(char l:0..3) {
	    for(char c:0..3) {
            char cell = *next_piece_gfx++;
			if(cell!=0) {
		        *screen_next_area = next_piece_char;
		    } else {
		        *screen_next_area = 0;
		    }
            screen_next_area++;
        }
		screen_next_area += 36;
	}
}

