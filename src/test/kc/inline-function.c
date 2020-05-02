// Test inline function
// Splits screen so upper half is lower case and lower half lower case

byte* RASTER = $d012;
byte* D018 = $d018;
byte* BG_COLOR = $d021;

byte* screen = $0400;
byte* charset1 = $1000;
byte* charset2 = $1800;

void main() {
    asm { sei }
    while(true) {
        while(*RASTER!=$ff) {}
        *D018 = toD018(screen, charset1);
        *BG_COLOR = $6;
        while(*RASTER!=$62) {}
        *D018 = toD018(screen, charset2);
        *BG_COLOR = $b;
    }
}

inline byte toD018( byte* screen, byte* charset) {
    return (byte)(((word)screen/$40)|((word)charset/$400));
}