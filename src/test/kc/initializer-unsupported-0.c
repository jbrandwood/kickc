// Unsupported initializer list

void main() {
    byte* screen = (byte*) { 4, 0 };
    *screen = 'a';
}