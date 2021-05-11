// Fills the screen using two unrolled ranged for()-loops

void main() {
    byte* SCREEN = (char*)$400;
    inline for(byte x: 0..10) {
        inline for(byte line: 0..10) {
            (SCREEN+line*40)[x] = x;
        }
    }

}