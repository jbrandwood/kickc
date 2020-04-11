// Tests a condition type mismatch (not boolean)

void main() {
    byte b = 12;
    if(b) {
        byte* screen = $400;
        *screen = 'a';
    }
}