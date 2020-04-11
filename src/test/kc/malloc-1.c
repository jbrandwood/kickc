// Experiments with malloc() - a word array

#include <stdlib.h>

word* WORDS = malloc(0x200);

void main() {
    word* w = WORDS;
    for( byte i: 0..255) {
        *w++ = i;
    }
}
