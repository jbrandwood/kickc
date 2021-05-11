// used vars
byte* const SCREEN = (byte*)$400;
byte b=2/2;

// unused vars
byte* const BG_COLOR = (char*)$d021;
byte msg[] = "hello world";
byte arr[] = { 7, 8, 9};
byte c=1;
const byte c2=1;
word d=1000;

void main() {
    // used vars
    byte col=2;
    byte* COLS=(byte*)$d800;
    // unused vars
    byte e=3+3+3+s(); // The call to s() should survive even when e is eliminated
    word f=2000+2000+d+b++; // b++ should survive even when f is eliminated.
    byte g[] = {4, 5, 6};
    byte h[] = "goodbye sky "z;
    for(byte i : 0..100) {
        // the last unused var
        signed byte x = -13;
        COLS[i] = col;
        SCREEN[i] = b;
    }
}

byte s() {
    b++;
    return 2;
}
