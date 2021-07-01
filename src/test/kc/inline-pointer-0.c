// Tests creating a literal pointer from two bytes

void main() {
    byte* screen = (byte*) MAKEWORD( 4, 0 );
    *screen = 'a';
}