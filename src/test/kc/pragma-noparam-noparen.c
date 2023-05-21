// Test that #pragma works with no parenthesis and no parameters

#pragma nobank

void main() {
    char * const SCREEN = (char*) 0x0400;
    *SCREEN = 'a';
}