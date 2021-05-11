// Typedef pointer to const/volatile type and instantiate it to const variable

char* const SCREEN = (char*)0x0400;

typedef const char * C;
typedef volatile char * V;

const C cp = (C)0xa003;
const V vp = (V)0xa004;

void main() {
    SCREEN[0] = *cp;
    SCREEN[1] = *vp;
}