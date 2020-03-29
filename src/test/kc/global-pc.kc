// Test setting the program PC through a #pc directive

#pragma pc(0x1000)

byte* const BGCOL = 0xd021;
byte* const RASTER = 0xd012;

void main() {
    asm { sei }
    while(true) {
        byte col = *RASTER;
        *BGCOL = col;
    }
}

