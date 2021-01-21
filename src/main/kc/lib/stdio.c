char * const GETIN = 0xFFE4;

char fgetc()
{
    char ch;
    asm {
        jsr GETIN
        sta ch
    }
    return ch;
}