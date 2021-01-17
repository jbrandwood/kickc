byte* const SCREEN = $0400;

void main() {
    byte a = 'a';
    for( byte i:0..3) {
        asm {
            lda #'a'
            sta SCREEN
        }
        a++;
    }

}
