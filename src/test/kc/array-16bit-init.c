// Demonstrates wrong padding for non-byte arrays.
// https://gitlab.com/camelot/kickc/-/issues/497

char* levelRowOff[31] = { 1, 2, 3 };

void main() {
    for(char c=0;c<sizeof(levelRowOff)/sizeof(char*); c++)
        levelRowOff[c] = (char*)12345;
}