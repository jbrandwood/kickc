// Typedef pointer to const/volatile type and instantiate it

char* const SCREEN = 0x0400;

typedef const char * C;
typedef volatile char * V;

C cp = 0xa003;
V vp = 0xa004;

void main() {
    SCREEN[0] = *cp;
    SCREEN[1] = *vp;
}