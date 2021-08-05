// Test using some simple supported string escape
// Test escaping of quotes in chars and strings

char * const SCREEN = (char*)0x0400;

char Q1 = '"';
char Q2 = '\'';
char S[] = "\"'";

void main() {
    SCREEN[40] = Q1;
    SCREEN[41] = Q2;
    for(char i=0;S[i];i++)
        SCREEN[i] = S[i];
}