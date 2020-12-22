// Tetris Game for the Commodore 64
// The tetris pieces

// The T-piece
__align(0x40) char PIECE_T[64] = {
	0, 0, 0, 0,
	1, 1, 1, 0,
	0, 1, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	1, 1, 0, 0,
	0, 1, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	1, 1, 1, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	0, 1, 1, 0,
	0, 1, 0, 0,
	0, 0, 0, 0
};

// The S-piece
__align(0x40) char PIECE_S[64] = {
	0, 0, 0, 0,  
	0, 1, 1, 0,
	1, 1, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 1, 0,
	0, 0, 0, 0,

	0, 0, 0, 0,
	0, 1, 1, 0,
	1, 1, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 1, 0,
	0, 0, 0, 0

};

// The Z-piece
__align(0x40) char PIECE_Z[64] = {
	0, 0, 0, 0,  
	1, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,

	0, 0, 1, 0,
	0, 1, 1, 0,
	0, 1, 0, 0,
	0, 0, 0, 0,

	0, 0, 0, 0,  
	1, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,

	0, 0, 1, 0,
	0, 1, 1, 0,
	0, 1, 0, 0,
	0, 0, 0, 0

};

// The L-piece
__align(0x40) char PIECE_L[64] = {
	0, 0, 0, 0,  
	1, 1, 1, 0,
	1, 0, 0, 0,
	0, 0, 0, 0,

	1, 1, 0, 0,
	0, 1, 0, 0,
	0, 1, 0, 0,
	0, 0, 0, 0,

	0, 0, 1, 0,  
	1, 1, 1, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	0, 1, 0, 0,
	0, 1, 1, 0,
	0, 0, 0, 0

};

// The J-piece
__align(0x40) char PIECE_J[64] = {
	0, 0, 0, 0,
	1, 1, 1, 0,
	0, 0, 1, 0,
	0, 0, 0, 0,

	0, 1, 0, 0,
	0, 1, 0, 0,
	1, 1, 0, 0,
	0, 0, 0, 0,

	1, 0, 0, 0,
	1, 1, 1, 0,
	0, 0, 0, 0,
	0, 0, 0, 0,

	0, 1, 1, 0,
	0, 1, 0, 0,
	0, 1, 0, 0,
	0, 0, 0, 0

};

// The O-piece
__align(0x40) char PIECE_O[64] = {
	0, 0, 0, 0,
	0, 1, 1, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,

	0, 0, 0, 0,
	0, 1, 1, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,

	0, 0, 0, 0,
	0, 1, 1, 0,
	0, 1, 1, 0,
	0, 0, 0, 0,

	0, 0, 0, 0,
	0, 1, 1, 0,
	0, 1, 1, 0,
	0, 0, 0, 0

};

// The I-piece
__align(0x40) char PIECE_I[64] = {
	0, 0, 0, 0,  
	0, 0, 0, 0,
	1, 1, 1, 1,
	0, 0, 0, 0,

	0, 1, 0, 0,  
	0, 1, 0, 0,
	0, 1, 0, 0,
	0, 1, 0, 0,

	0, 0, 0, 0,  
	0, 0, 0, 0,
	1, 1, 1, 1,
	0, 0, 0, 0,

	0, 1, 0, 0,  
	0, 1, 0, 0,
	0, 1, 0, 0,
	0, 1, 0, 0

};

// The different pieces
unsigned int PIECES[] = { (unsigned int)PIECE_T, (unsigned int)PIECE_S, (unsigned int)PIECE_Z, (unsigned int)PIECE_J, (unsigned int)PIECE_O, (unsigned int)PIECE_I, (unsigned int)PIECE_L };

// The chars to use for the different pieces - when inside the playing area
char PIECES_CHARS[] = {  0x65, 0x66, 0xa6, 0x66, 0x65, 0x65, 0xa6 };

// The chars to use for the different pieces - when outside the playing area (eg. the next area).
char PIECES_NEXT_CHARS[] = {  0x63, 0x64, 0xa4, 0x64, 0x63, 0x63, 0xa4 };

// The initial X/Y for each piece
char PIECES_START_X[] = {  4, 4, 4, 4, 4, 4, 4 };
char PIECES_START_Y[] = {  1, 1, 1, 1, 1, 0, 1 };