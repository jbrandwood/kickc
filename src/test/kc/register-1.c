// Test declaring a variable as at a hard-coded register
// Unknown hard-coded register

void main() {
    char* const SCREEN = (char*)0x0400;
    char register(H) idx = 3;
    while(idx++<7)
        SCREEN[idx] = 'a';
}

