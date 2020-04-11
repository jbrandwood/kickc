// Test some forced zeropage access


void main() {

    word u = 555;
    u = *(word *)0xA0 - u;

    *((word*)0x0400) = u;

    *(byte **)0xF3 = *(byte **)0xD1 + 0xD400;
}