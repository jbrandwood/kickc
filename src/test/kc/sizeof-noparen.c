// Tests the sizeof operator without parenthesis

char* const SCREEN = (char*)0x400;

void main() {
    char idx = 0;

    // Simple types
    char b = 0;
    int w = 0;

    SCREEN[idx++] = '0'+sizeof 0;
    SCREEN[idx++] = '0'+sizeof b;
    SCREEN[idx++] = '0'+sizeof w;
    SCREEN[idx++] = '0'+sizeof (char);
    SCREEN[idx++] = '0'+sizeof (int);

}