// Provides provide bitmap output
// Currently C64/PLUS4/VIC20/CX16 platforms are supported
#if defined(__CX16__)
#include "bitmap-cx16.h"
#elif defined(__C64__)
#include "bitmap-c64.h"
#else
#error "Target platform does not support bitmap.h"
#endif