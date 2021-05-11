
typedef byte uint8;

void main() {
    uint8 b = 'a';
    uint8* SCREEN = (char*)0x0400;
    *SCREEN = b;
}