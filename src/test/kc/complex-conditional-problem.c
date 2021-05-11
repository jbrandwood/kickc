// Test to provoke Exception when using complex || condition

byte* const RASTER = (byte*)$d012;
byte* const SCREEN = (byte*)$0400;

void main() {
    while(true) {
        byte key = *RASTER;
        if (key > $20 || key < $40) {
            key = 0;
        }
        *SCREEN = key;
    }
}
