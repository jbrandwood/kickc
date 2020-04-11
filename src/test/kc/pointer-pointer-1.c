// Tests a simple pointer to a pointer

void main() {
    byte* const SCREEN = $400;

    byte b = 'a';
    byte* pb = &b;
    byte** ppb = &pb;
    *SCREEN = **ppb;

}