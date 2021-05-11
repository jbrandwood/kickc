// Test an unknown pragma

#pragma unknown(x)

char * const SCREEN = (char*)0x0400;

void main() {
    *SCREEN = 'a';
}