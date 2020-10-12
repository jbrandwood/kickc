// Demonstrates a problem where constant references are not literal

char A[] = "qwe";
char * B = 0x8000;

void main() {
    copy(B, A);
}

// Copy a byte if the destination is after the source
void copy(void* destination, void* source) {
    if((unsigned int)destination>(unsigned int)source) {
        char* src = source;
        char* dst = destination;
        *dst = *src;
    }
}
