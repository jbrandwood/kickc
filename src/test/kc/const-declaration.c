// Tests a number of constant declarations

char* const SCREEN = (char*)0x0400;
const char LINE_LEN = 40;
const char MARGIN_TOP = 4;
const char MARGIN_LEFT = 4;
const unsigned int OFFSET = 40*5+5;
char* const BODY1 = SCREEN+MARGIN_TOP*LINE_LEN+MARGIN_LEFT;
char* const BODY2 = SCREEN+OFFSET;

void main() {
    *BODY1 = '*';
    *BODY2 = '*';
}



