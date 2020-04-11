// Illustrates a problem where absolute addressing is used for zeropage-access
// This is caused by the compiler believing the pointer is into memory" (not knowing the upper part is 0x00 )

void main() {
    unsigned dword t;
    unsigned char *c=(unsigned char *)&t;
    *(unsigned char *)0x0400 = c[0];
}
