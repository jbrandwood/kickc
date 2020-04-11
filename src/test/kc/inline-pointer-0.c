// Tests creating a literal pointer from two bytes

void main() {
    byte* screen = (byte*) { 4, 0 };
    *screen = 'a';
}