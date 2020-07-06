// Illustrates a problem with post-incrementing inside the while loop condition
// https://gitlab.com/camelot/kickc/-/issues/486

const unsigned char mmap[] = {
    0x02, 0x5c, 0x1a, 0x03, 0x60, 0x1a, 0x07
};

void main(void)
{
    unsigned char *ptr = mmap;
    unsigned char n = *(ptr++);
    while (n--)
        *((unsigned char *)0x400) = n;
}
