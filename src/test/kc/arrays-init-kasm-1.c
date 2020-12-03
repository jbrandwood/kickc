// Test initializing array using KickAssembler
// Place array at hardcoded address

// Sine table at an absolute address in memory
__address(0x1000) char SINTAB[256] = kickasm {{
    .fill 256, 128 + 128*sin(i*2*PI/256)
}};

char* SCREEN = 0x400;

void main() {
    SCREEN[0] = SINTAB[0];
}