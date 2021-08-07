// Test labels/goto
// a few simple labels

void main() {
    label1:
    char * const SCREEN = (char*)0x0400;
    label2:
    for(char i=0;i<10;i++) {
        label3:
        SCREEN[i] = i;
        label4:
    }
    label5:
    SCREEN[40] = '*';
    label6:
}