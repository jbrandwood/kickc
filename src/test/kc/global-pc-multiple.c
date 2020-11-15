// Test setting the program PC through a #pc directive


byte* const BG_COLOR = 0xd021;
byte* const RASTER = 0xd012;

#pragma start_address(0x1000)

void main() {
    asm { sei }
    while(true) {
        if(*RASTER<30)
            incScreen();
        else
            *BG_COLOR = 0;
    }
}

#pragma start_address(0x2000)

void incScreen() {
    *BG_COLOR = *RASTER;
}