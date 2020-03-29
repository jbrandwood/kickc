// Test setting the program PC through a #pc directive


byte* const BGCOL = 0xd021;
byte* const RASTER = 0xd012;

#pragma pc(0x1000)

void main() {
    asm { sei }
    while(true) {
        if(*RASTER<30)
            incScreen();
        else
            *BGCOL = 0;
    }
}

#pragma pc(0x2000)

void incScreen() {
    *BGCOL = *RASTER;
}