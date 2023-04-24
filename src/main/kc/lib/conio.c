// Provides provide console input/output
// Implements similar functions as conio.h from CC65 for compatibility
// See https://github.com/cc65/cc65/blob/master/include/conio.h
//
// Currently C64/PLUS4/VIC20 platforms are supported
#include <conio.h>

#if defined(__C64__)
#include "conio-c64.c"
#elif defined(__C128__)
#include "conio-c128.c"
#elif defined(__PLUS4__)
#include "conio-plus4.c"
#elif defined(__VIC20__)
#include "conio-vic20.c"
#elif defined(__MEGA65__)
#include "conio-mega65.c"
#elif defined(__NES__)
#include "conio-nes.c"
#elif defined(__ATARIXL__)
#include "conio-atarixl.c"
#elif defined(__CX16__)
#include "cx16-conio.c"
#elif defined(__PET8032__)
#include "pet-conio.c"
#else
#error "Target platform does not support conio.h"
#endif

