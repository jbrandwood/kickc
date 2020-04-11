// Fills the screen using an unrolled inner ranged for()-loop

void main() {
    byte* SCREEN = $400;

    for(byte x: 0..39) {
        inline for(byte line: 0..24) {
            (SCREEN+line*40)[x] = x;
        }

    }

}