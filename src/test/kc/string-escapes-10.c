// Test octal escapes in chars

char MSG1 = '\1';
char MSG2 = '\02';
char MSG3 = '\003';
char MSG4 = '\377';
char* SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = MSG1;
    SCREEN[1] = MSG2;
    SCREEN[2] = MSG3;
    SCREEN[3] = MSG4;
}