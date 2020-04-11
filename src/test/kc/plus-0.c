// Tests elimination of plus 0

void main() {
    fill((byte*)$400,'a');
    fill((byte*)$2000,'b');
}

void fill(byte* screen, byte ch) {
    for(byte i: 0..39) {
        inline for( byte j: 0..2 ) {
            (screen+j*40)[i] = ch;
        }
    }
}