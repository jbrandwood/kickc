// Plus/4 / Commodore 16 registers and memory layout
#include <mos7360.h>

// The TED chip controlling video and sound on the Plus/4 and Commodore 16
struct MOS7360_TED * const TED = 0xff00;

// Default address of screen luminance/color matrix
char * const DEFAULT_COLORRAM = 0x0800;

// Default address of screen character matrix
char * const DEFAULT_SCREEN = 0x0c00;

