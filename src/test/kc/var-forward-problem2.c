// Illustrates the problem with variable forward references not working

void main() {
    screen = (byte*)$400;
    b = 'a';
    *screen = b;
}

byte* screen;
byte b;