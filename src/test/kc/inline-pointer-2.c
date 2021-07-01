// Tests creating a literal pointer from two bytes

void main() {
    byte* screen = (byte*)MAKEWORD( 4, 0 ) + (word)MAKEWORD( 0, 40 );
    *screen = 'a';
}