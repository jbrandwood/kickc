// Test a short array initializer - the rest should be zero-filled

char msg1[16] ="camelot";
char msg2[16] = { 'c', 'm', 'l' };

char* const SCREEN = (char*)0x400;

void main() {
    for(char i=0;msg1[i];i++)
        SCREEN[i] = msg1[i];
    for(char i=0;msg2[i];i++)
        (SCREEN+40)[i] = msg2[i];
}