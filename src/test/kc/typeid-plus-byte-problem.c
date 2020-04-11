// Test that byte+byte creates a byte - even when there is a value overflow

byte* const SCREEN = $400;

void main() {
    unsigned byte ubc1 = 12+13+14;
    unsigned byte ubc2 = 250;
    SCREEN[0] = ubc1+ubc2;
}

