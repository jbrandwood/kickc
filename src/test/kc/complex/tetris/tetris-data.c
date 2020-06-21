// Tetris Game for the Commodore 64
// Memory Layout and Shared Data

// Address of the first screen
char* const PLAYFIELD_SCREEN_1 = 0x0400;
// Address of the second screen
char* const PLAYFIELD_SCREEN_2 = 0x2c00;
// Screen Sprite pointers on screen 1
char* const PLAYFIELD_SPRITE_PTRS_1 = (PLAYFIELD_SCREEN_1+SPRITE_PTRS);
// Screen Sprite pointers on screen 2
char* const PLAYFIELD_SPRITE_PTRS_2 = (PLAYFIELD_SCREEN_2+SPRITE_PTRS);

// Sprites covering the playfield
__address(0x3000) char PLAYFIELD_SPRITES[30*64] = kickasm(resource "playfield-sprites.png") {{
	.var sprites = LoadPicture("playfield-sprites.png", List().add($010101, $000000))
	// Put the sprites into memory
	.for(var sy=0;sy<10;sy++) {
	    .var sprite_gfx_y = sy*20
		.for(var sx=0;sx<3;sx++) {
	    	.for (var y=0;y<21; y++) {
	    	    .var gfx_y =  sprite_gfx_y + mod(2100+y-sprite_gfx_y,21)
		    	.for (var c=0; c<3; c++) {
	            	.byte sprites.getSinglecolorByte(sx*3+c,gfx_y)
	            }
	        }
	    	.byte 0
	  	}
	}
}};

// Address of the charset
__address(0x2800) char PLAYFIELD_CHARSET[] = kickasm(resource "playfield-screen.imap") {{
    .fill 8,$00 // Place a filled char at the start of the charset
    .import binary "playfield-screen.imap"
}};

// The size of the playfield
const char PLAYFIELD_LINES = 22;
const char PLAYFIELD_COLS = 10;

// The playfield.  0 is empty non-zero is color.
// The playfield is layed out line by line, meaning the first 10 bytes are line 1, the next 10 line 2 and so forth,
char playfield[PLAYFIELD_LINES*PLAYFIELD_COLS];

// Pointer to the current piece in the current orientation. Updated each time current_orientation is updated.
char* current_piece_gfx;

// The char of the current piece
char current_piece_char;

// Position of top left corner of current moving piece on the playfield
char current_xpos;
char current_ypos;

// The screen currently being rendered to. 0x00 for screen 1 / 0x20 for screen 2.
char render_screen_render = 0x20;
// The screen currently to show next to the user. 0x00 for screen 1 / 0x20 for screen 2.
char render_screen_show = 0;
// The screen currently being showed to the user. 0x00 for screen 1 / 0x20 for screen 2.
volatile char render_screen_showing = 0;

// Current score in BCD-format
unsigned long  score_bcd = 0;
// Current number of cleared lines in BCD-format
unsigned int lines_bcd = 0;
// Current level BCD-format
char level_bcd = 0;
// Current level in normal (non-BCD) format
char level = 0;
// Is the game over?
char game_over = 0;

