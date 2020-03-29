// Illustrates how inline assembler referencing variables is illegal

byte* const SCREEN = $400;

void main() {
    for( __ssa byte i: 0..10) {
        asm {
            lda #'a'
            ldx i
            sta SCREEN,x
        }
    }

}