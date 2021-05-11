// Typedef a const/volatile type and instantiate a pointer to it

char* const SCREEN = (char*)0x0400;

typedef const char C;
typedef volatile char V;

C * cp = (C*)0xa003;
V * vp = (V*)0xa004;

void main() {
    SCREEN[0] = *cp;
    SCREEN[1] = *vp;
}