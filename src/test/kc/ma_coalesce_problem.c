// Demonstrates problem with __ma coalescing
// c1a is erroneously zp-coalesced with c1A

#pragma var_model(ma_mem)

char* const SCREEN = 0x0400;

// Plasma state variables
char c1A = 0;

void main() {
    while(true) {
        char c1a = c1A;
        for (char i = 0; i < 40; ++i) {
            SCREEN[i] = SINTABLE[c1a];
            c1a += 4;
        }
        c1A += 3;
    }
}

const char __align(0x100) SINTABLE[0x100] = kickasm {{
    .for(var i=0;i<$100;i++)
        .byte round(127.5+127.5*sin(2*PI*i/256))
}};

