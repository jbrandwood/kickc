// Test declaring a variable as register on a specific ZP address

int* SCREEN = 0x0400;

void main() {
    __address(0x2) char i=0;
    __address(0x4) int j=0;
    while(i<4) {
        SCREEN[i++] = j++;
        int k = (int)i*2;
        SCREEN[i++] = k;
    }
}
