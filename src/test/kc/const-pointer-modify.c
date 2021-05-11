// Test that modifying constant pointers fail

void main() {
    byte* const screen = (byte*)$400;
    screen[0] = 'c';
    screen++;
    screen[0] = 'm';
}