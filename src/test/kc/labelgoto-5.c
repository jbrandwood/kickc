// Test labels/goto
// goto a label nested in a loop

void main() {
    char * const SCREEN = (char*)0x0400;
    char i = 0;
    goto first;
    for(;i<10;i++) {
        SCREEN[i] = '*';
        first:
        SCREEN[40]++;
    }
}