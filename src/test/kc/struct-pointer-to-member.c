// Support for pointer to struct member

// Commodore 64 screen colors
struct SCREEN_COLORS {
    char BORDER;
    char BG0;
    char BG1;
    char BG2;
    char BG3;
};

// Commodore 64 processor port
struct SCREEN_COLORS* const COLORS = (struct SCREEN_COLORS*)0xd020;

// The border color
char * const BORDER_COLOR = &COLORS->BORDER;
// The background color
char * const BG_COLOR = &COLORS->BG0;

void main() {
    COLORS->BORDER = 0;
    *BG_COLOR = 6;
}