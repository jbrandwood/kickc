// Test declaring a variable as register on a specific ZP address

int* SCREEN = (int*)0x0400;

void main() {
    __address(257) char i=0;
}
