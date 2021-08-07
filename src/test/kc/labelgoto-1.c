// Test labels/goto
// a duplicate label

void main() {
    label1:
    char * const SCREEN = (char*)0x0400;
    label1:
}