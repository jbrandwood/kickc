/// @file
/// Provides provide simple horisontal/vertical lines routines on top of conio.h
///  For compatibility with CC65 https://github.com/cc65/cc65/blob/master/include/conio.h

#include <conio.h>

/// The horizontal line character
const char CH_HLINE = 0x40;
/// The vertical line character
const char CH_VLINE = 0x5d;
/// The upper left corner character
const char CH_ULCORNER = 0x70;
/// The upper right corner character
const char CH_URCORNER = 0x6e;
/// The lower left corner character
const char CH_LLCORNER = 0x6d;
/// The lower right corner character
const char CH_LRCORNER = 0x7d;
/// The left T character
const char CH_LTEE = 0x6b;
/// The right T character
const char CH_RTEE = 0x73;

/// Output a horizontal line with the given length starting at the current cursor position.
void chline(unsigned char length);

/// Output a vertical line with the given length at the current cursor position.
void cvline(unsigned char length);

/// Move cursor and output a vertical line with the given length
/// Same as "gotoxy (x, y); cvline (length);"
void cvlinexy(unsigned char x, unsigned char y, unsigned char length);

