// Test minimization of constants

#include <c64.h>

void main() {
    byte* const PLAYFIELD_CHARSET = (byte*)$2800;
	vicSelectGfxBank(PLAYFIELD_CHARSET);
}
