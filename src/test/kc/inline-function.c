// Test inline function
// Splits screen so upper half is lower case and lower half lower case

byte* RASTER = (byte*)$d012;
byte* D018 = (byte*)$d018;
byte* BG_COLOR = (byte*)$d021;

byte* screen = (byte*)$400;
byte* charset1 = (byte*)$1000;
byte* charset2 = (byte*)$1800;

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