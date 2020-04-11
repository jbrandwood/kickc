// Tetris Game for the Commodore 64
// Implementation of the tetris game play logic. Most of the logic is modelled after NES tetris
// Source: https://meatfighter.com/nintendotetrisai/

#include "tetris-data.c"
#include "tetris-pieces.c"

// Pointers to the playfield address for each playfield line
char* playfield_lines[PLAYFIELD_LINES];

// Indixes into the playfield  for each playfield line
char playfield_lines_idx[PLAYFIELD_LINES+1];

// The index of the next moving piece. (0-6)
char next_piece_idx = 0;

// The current moving piece. Points to the start of the piece definition.
char* current_piece = 0;

// The curent piece orientation - each piece have 4 orientations (00/0x10/0x20/0x30).
// The orientation chooses one of the 4 sub-graphics of the piece.
char current_orientation = 0;

// The speed of moving down the piece when soft-drop is not activated
// This array holds the number of frames per move by level (0-29). For all levels 29+ the value is 1.
const char MOVEDOWN_SLOW_SPEEDS[] = { 48, 43, 38, 33, 28, 23, 18, 13, 8, 6, 5, 5, 5, 4, 4, 4, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1 };

// The rate of moving down the current piece (number of frames between moves if movedown is  not forced)
char current_movedown_slow = 48;

// The rate of moving down the current piece fast (number of frames between moves if movedown is not forced)
const char current_movedown_fast = 10;

// Counts up to the next movedown of current piece
char current_movedown_counter = 0;

// Base Score values for removing 0-4 lines (in BCD)
// These values are added to score_add_bcd for each level gained.
const unsigned long SCORE_BASE_BCD[] = { 0x0000, 0x0040, 0x0100, 0x0300, 0x1200 };

// Score values for removing 0-4 lines (in BCD)
// These values are updated based on the players level and the base values from SCORE_BASE_BCD
unsigned long score_add_bcd[5];

// Initialize play data tables
void play_init() {
	// Initialize the playfield line pointers;
	char idx = 0;
	char* pli = playfield;
	for(char j:0..PLAYFIELD_LINES-1) {
		playfield_lines[j] = pli;
		playfield_lines_idx[j] = idx;
		pli += PLAYFIELD_COLS;
		idx += PLAYFIELD_COLS;
	}
	playfield_lines_idx[PLAYFIELD_LINES] = PLAYFIELD_COLS*PLAYFIELD_LINES;

	// Set initial speed of moving down a tetromino
	current_movedown_slow = MOVEDOWN_SLOW_SPEEDS[level];
	// Set the initial score add values
    for(char b: 0..4) {
        score_add_bcd[b] = SCORE_BASE_BCD[b];
    }

}

// Perform any movement of the current piece
// key_event is the next keyboard_event() og 0xff if no keyboard event is pending
// Returns a byte signaling whether rendering is needed. (0 no render, >0 render needed)
char play_movement(char key_event) {
    char render = 0;
	render += play_move_down(key_event);
	if(game_over!=0) {
	    return render;
	}
	render += play_move_leftright(key_event);
	render += play_move_rotate(key_event);
	return render;
}

// Move down the current piece
// Return non-zero if a render is needed
char play_move_down(byte key_event) {
		// Handle moving down current piece
		++current_movedown_counter;
		char movedown = 0;
		// As soon as space is pressed move down once
		if(key_event==KEY_SPACE) {
			movedown++;
		}
		// While space is held down move down faster
		if(keyboard_event_pressed(KEY_SPACE)!=0) {
			if(current_movedown_counter>=current_movedown_fast) {
				movedown++;
			}
		}
		// Move down slowly otherwise
		if(current_movedown_counter>=current_movedown_slow) {
			movedown++;
		}
		// Attempt movedown
		if(movedown!=0) {
			if(play_collision(current_xpos,current_ypos+1,current_orientation)==COLLISION_NONE) {
				// Move current piece down
				current_ypos++;
			} else {
				// Lock current piece
				play_lock_current();
				// Check for any lines and remove them
				char removed = play_remove_lines();
				// Tally up the score
				play_update_score(removed);
				// Spawn a new piece
				play_spawn_current();
			}
			current_movedown_counter = 0;
			return 1;
		}
		return 0;
}

// Move left/right or rotate the current piece
// Return non-zero if a render is needed
char play_move_leftright(char key_event) {
		// Handle keyboard events
		if(key_event==KEY_COMMA) {
			if(play_collision(current_xpos-1,current_ypos,current_orientation)==COLLISION_NONE) {
				current_xpos--;
				return 1;
			}
		} else if(key_event==KEY_DOT) {
			if(play_collision(current_xpos+1,current_ypos,current_orientation)==COLLISION_NONE) {
				current_xpos++;
				return 1;
			}
		}
		return 0;
}

// Rotate the current piece  based on key-presses
// Return non-zero if a render is needed
char play_move_rotate(char key_event) {
	// Handle keyboard events
	char orientation = 0x80;
	if(key_event==KEY_Z) {
		orientation = (current_orientation-0x10)&0x3f;
	} else if(key_event==KEY_X) {
		orientation = (current_orientation+0x10)&0x3f;
	} else {
		return 0;
	}
	if(play_collision(current_xpos, current_ypos, orientation) == COLLISION_NONE) {
		current_orientation = orientation;
		current_piece_gfx = current_piece + current_orientation;
		return 1;
	}
	return 0;
}

// No collision
const char COLLISION_NONE = 0;
// Playfield piece collision (cell on top of other cell on the playfield)
const char COLLISION_PLAYFIELD = 1;
// Bottom collision (cell below bottom of the playfield)
const char COLLISION_BOTTOM = 2;
// Left side collision (cell beyond the left side of the playfield)
const char COLLISION_LEFT = 4;
// Right side collision (cell beyond the right side of the playfield)
const char COLLISION_RIGHT = 8;

// Test if there is a collision between the current piece moved to (x, y) and anything on the playfield or the playfield boundaries
// Returns information about the type of the collision detected
char play_collision(char xpos, char ypos, char orientation) {
	char* piece_gfx = current_piece + orientation;
	char i = 0;
	char yp = ypos;
	for(char l:0..3) {
		char* playfield_line = playfield_lines[yp];
		char xp = xpos;
		for(char c:0..3) {
			if(piece_gfx[i++]!=0) {
				if(yp>=PLAYFIELD_LINES) {
					// Below the playfield bottom
					return COLLISION_BOTTOM;
				}
				if((xp&0x80)!=0) {
					// Beyond left side of the playfield
					return COLLISION_LEFT;
				}
				if(xp>=PLAYFIELD_COLS) {
					// Beyond left side of the playfield
					return COLLISION_RIGHT;
				}
				if(playfield_line[xp]!=0) {
					// Collision with a playfield cell
					return COLLISION_PLAYFIELD;
				}
			}
			xp++;
		}
		yp++;
	}
	return COLLISION_NONE;
}

// Lock the current piece onto the playfield
void play_lock_current() {
	char i = 0;
	char yp = current_ypos;
	for(char l:0..3) {
		char* playfield_line = playfield_lines[yp];
		char xp = current_xpos;
		for(char c:0..3) {
			if(current_piece_gfx[i++]!=0) {
				playfield_line[xp] = current_piece_char;
			}
			xp++;
		}
		yp++;
	}
}

// Spawn a new piece
// Moves the next piece into the current and spawns a new next piece
void play_spawn_current() {
    // Move next piece into current
	char current_piece_idx = next_piece_idx;
	current_piece = PIECES[current_piece_idx];
	current_piece_char = PIECES_CHARS[current_piece_idx];
	current_orientation = 0;
	current_piece_gfx = current_piece + current_orientation;
	current_xpos = PIECES_START_X[current_piece_idx];
	current_ypos = PIECES_START_Y[current_piece_idx];
	if(play_collision(current_xpos,current_ypos,current_orientation)==COLLISION_PLAYFIELD) {
	    game_over = 1;
	}

    // Spawn a new next piece
	// Pick a random piece (0-6)
	char piece_idx = 7;
	while(piece_idx==7) {
		piece_idx = sid_rnd()&7;
	}
	next_piece_idx = piece_idx;

}

// Look through the playfield for lines - and remove any lines found
// Utilizes two cursors on the playfield - one reading cells and one writing cells
// Whenever a full line is detected the writing cursor is instructed to write to the same line once more.
// Returns the number of lines removed
char play_remove_lines() {
	// Start both cursors at the end of the playfield
	char r = PLAYFIELD_LINES*PLAYFIELD_COLS-1;
	char w = PLAYFIELD_LINES*PLAYFIELD_COLS-1;

    char removed = 0;
	// Read all lines and rewrite them
	for(char y:0..PLAYFIELD_LINES-1) {
		char full = 1;
		for(char x:0..PLAYFIELD_COLS-1) {
			char c = playfield[r--];
			if(c==0) {
				full = 0;
			}
			playfield[w--] = c;
		}
		// If a line is full then re-write it.
		if(full==1) {
			w = w + PLAYFIELD_COLS;
			removed++;
		}
	}

	// Write zeros in the rest of the lines
	while(w!=0xff) {
		playfield[w--] = 0;
	}
	// Return the number of removed lines
	return removed;
}

// Update the score based on the number of lines removed
void play_update_score(char removed) {
    if(removed!=0){
        char lines_before = <lines_bcd&0xf0;
        unsigned long add_bcd = score_add_bcd[removed];

        asm { sed }
        lines_bcd += removed;
        score_bcd += add_bcd;
        asm { cld }

        // If line 10-part updated increase the level
        char lines_after = <lines_bcd&0xf0;
        if(lines_before!=lines_after) {
            play_increase_level();
        }
    }
}

// Increase the level
void play_increase_level() {
    // Increase level
    level++;
    // Update speed of moving tetrominos down
    if(level>29) {
        current_movedown_slow = 1;
    } else {
        current_movedown_slow = MOVEDOWN_SLOW_SPEEDS[level];
    }
    // Increase BCD-format level
    level_bcd++;
    if((level_bcd&0xf)==0xa) {
         // If level low nybble hits 0xa change to 0x10
        level_bcd += 6;
    }
    // Increase the score values gained
 	asm { sed }
    for(char b: 0..4) {
        score_add_bcd[b] += SCORE_BASE_BCD[b];
    }
 	asm { cld }
}
