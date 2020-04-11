// Experiments with malloc() - a byte array

#include <stdlib.c>

byte* BYTES = malloc(0x100);

void main() {
    for( byte i: 0..255) {
        BYTES[i] = i;
    }
}
