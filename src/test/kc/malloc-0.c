// Experiments with malloc() - a byte array

#include <stdlib.h>

byte* BYTES = malloc(0x100);

void main() {
    for( byte i: 0..255) {
        BYTES[i] = i;
    }
}
