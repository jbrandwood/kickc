// Test minimal inline function

byte* screen = (byte*)$400;

void main() {
    screen[0] = sum(2, 1);
    screen[1] = sum(10, 3);
    screen[2] = sum(4, 8);
}

inline byte sum( byte a, byte b) {
    return a+b;
}