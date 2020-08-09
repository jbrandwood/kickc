// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently C64/PLUS4/VIC20 platforms are supported
#include <conio.h>

#if defined(__C64__)
#include "conio-c64.c"
#elif defined(__PLUS4__)
#include "conio-plus4.c"
#elif defined(__VIC20__)
#include "conio-vic20.c"
#elif defined(__MEGA65__)
#include "conio-mega65.c"
#elif defined(__NES__)
#include "conio-nes.c"
#else
#error "Target platform does not support conio.h"
#endif

