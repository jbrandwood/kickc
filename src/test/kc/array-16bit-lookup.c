// Test KickC performance for 16-bit array lookup function from article "Optimizing C array lookups for the 6502"
// http://8bitworkshop.com/blog/compilers/2019/03/17/cc65-optimization.html

void main() {
    unsigned int* SCREEN = (unsigned int*)0x0400;
    for(unsigned char idx : 0..128)
        SCREEN[idx] = getValue(idx);
}

unsigned int arr16[128];

unsigned int getValue(unsigned int index) {
    return (unsigned int)((arr16[index & 0x7f] & 0xff) >> 1);
}
