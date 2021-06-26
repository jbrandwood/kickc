void main()
{
    volatile unsigned char test;
    asm {
        sty test,x
    }
}