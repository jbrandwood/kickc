// Test that memory alignment of arrays work

byte align($100) bs[$100];

void main() {
    byte align($100) cs[$100];
    for( byte i: 0..255) {
        bs[i] = i;
    }
    byte j=255;
    for( byte i: 0..255) {
        cs[i] = bs[j--];
    }


}