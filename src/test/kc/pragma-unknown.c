// Test an unknown pragma

#pragma unknown(x)

char * const SCREEN = 0x0400;

void main() {
    *SCREEN = 'a';
}