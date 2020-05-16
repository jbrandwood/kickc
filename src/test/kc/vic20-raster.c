// VIC 20 Raster bars
#pragma target(vic20basic)
#include <vic20.h>

void main() {
    asm { sei }
    while(1) {
        VIC->BORDER_BACKGROUND_COLOR = VIC->RASTER;
    }
}