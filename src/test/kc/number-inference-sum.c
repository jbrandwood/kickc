// Test inference of number types using a long sum
// Currently fails - because the compiler does not handle byte+byte correctly (not truncating the result to 8 bits)

void main() {
    word* const screen = 0x0400;
    byte* const BG_COLOR = 0xd020;
    const byte RED = 2;

    byte b1 = 250;
    byte b2 = b1+250;
    word w = b2+1;
    screen[0] = w;

    if((w)>255) *BG_COLOR = RED;

}