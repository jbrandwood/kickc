// Test setting the program PC through a #pc directive

#pragma start_address(0x1000)

byte* const BG_COLOR = 0xd021;
byte* const RASTER = 0xd012;

void main() {
    asm { sei }
    while(true) {
        byte col = *RASTER;
        *BG_COLOR = col;
    }
}

