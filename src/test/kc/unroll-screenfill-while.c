// Fills the screen using an unrolled inner while()-loop

void main() {
    byte* SCREEN = (char*)$400;
    for(byte x: 0..39) {
     byte line = 0;
     inline while(line!=25) {
        (SCREEN+line*40)[x] = x;
        line++;
     }
    }

}