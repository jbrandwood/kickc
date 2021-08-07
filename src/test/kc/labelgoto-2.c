// Test labels/goto
// a simple goto a forward label

void main() {
    char * const SCREEN = (char*)0x0400;
    goto skip;
    SCREEN[0] = '*';
    skip:
    SCREEN[1] = '*';
}