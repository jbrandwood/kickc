// Test initializing array using KickAssembler

// Sine table
byte SINTAB[256] = kickasm {{
    .fill 256, 128 + 128*sin(i*2*PI/256)
}};

byte* SCREEN = (char*)0x400;

void main() {
    SCREEN[0] = SINTAB[0];

}