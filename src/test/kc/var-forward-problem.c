// Illustrates the problem with variable forward references not working

void main() {
    *screen = b;
}

byte* const screen = (char*)$400;
const byte b = 'a';