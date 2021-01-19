// Provides provide bitmap output
// Currently C64/PLUS4/VIC20/CX16 platforms are supported
#include <bitmap-draw.h>

#if defined(__CX16__)
#include "bitmap-draw-cx16.c"
#elif defined(__C64__)
#include "bitmap-draw-c64.c"
#else
#error "Target platform does not support bitmap-draw.h"
#endif