// Test labels/goto
// goto undefined label

void main() {
    char * const SCREEN = (char*)0x0400;
    goto skip;
    SCREEN[0] = '*';
}