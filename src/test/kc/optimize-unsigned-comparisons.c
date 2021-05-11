// Examples of unsigned comparisons to values outside the range of unsigned
// These should be optimized to constants

byte ball_active[8] = { 0, 1, 0, 1, 0, 1, 1, 1 };

void main() {
    byte* const screen = (char*)0x0400;
    byte temp;
    for( char i: 0..7) {
        // Always false
        if (ball_active[i]<0) {
            screen[i] = '-';
        }
        temp = ball_active[i];
    }
    // Always false
    if (temp<0) {
        screen[40] = temp;
    }

}
