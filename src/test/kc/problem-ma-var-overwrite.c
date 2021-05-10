// Demonstrates that a local __ma variable overwrites a parameter§

unsigned char *volatile h1;  // This must be volatile because is used in an interrupt routine...

void test(unsigned char *videoMem, unsigned char *colorMem, unsigned char *other)
{
    unsigned int diff;
    __ma unsigned char *dst;  // This must be declared as __ma because is used in an assembly routine...


    diff = colorMem - videoMem;
    dst = other + ((unsigned int)diff);
    dst[0] = 1;

    asm {
        ldy #0
        lda #1
        sta (dst),y
    }
}

void main(void)
{
    test(h1, (char*)0xD800, (char*)0xC000);
}
