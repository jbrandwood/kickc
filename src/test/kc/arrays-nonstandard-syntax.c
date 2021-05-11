// Test non-standard array syntax char[8]

char[16] msg ="camelot";

char* const SCREEN = (char*)0x400;

void main() {
    for(char i=0;msg[i];i++)
        SCREEN[i] = msg1[i];
}