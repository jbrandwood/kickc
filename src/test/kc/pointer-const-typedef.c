// Test pointer to const and const pointer combined with typedef

// Const char typedef
typedef const char CC;

// Pointer typedef
typedef char * P;

// Pointer to const typedef
typedef const char * PC;

// Const pointer typedef
typedef char * const CP;

// Pointer to const
const char * pc0 = 0x0400;
CC *pc1 = 0x0400;
PC pc2 = 0x0400;

// Const pointer
char * const cp0 = 0x0400;
CP cp1 = 0x0400;
const P cp2 = 0x0400;

// Const pointer to const
const char * const cpc0 = 0x0400;
CC * const cpc1 = 0x0400;
const PC cpc2 = 0x0400;

char* SCREEN = 0x0400;

void main() {
    char idx = 0;
    SCREEN[idx++] = *pc0;
    SCREEN[idx++] = *pc1;
    SCREEN[idx++] = *pc2;
    SCREEN[idx++] = *cp0;
    SCREEN[idx++] = *cp1;
    SCREEN[idx++] = *cp2;
    SCREEN[idx++] = *cpc0;
    SCREEN[idx++] = *cpc1;
    SCREEN[idx++] = *cpc2;
}