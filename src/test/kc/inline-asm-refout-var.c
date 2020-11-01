// Illustrates how inline assembler referencing variables is automatically converted to __ma

byte* const SCREEN = $400;

void main() {
    for(byte i: 0..10) {
        asm {
            lda #'a'
            ldx i
            sta SCREEN,x
        }
    }

}