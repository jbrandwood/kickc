// Problem with eliminating unused blocks/vars after the infinite loop (symbol line#2 not removed from symbol table)

void main() {
    byte* SCREEN = $400;
    while(true) {
        (*SCREEN)++;
    }
    for(byte line: 0..24) {
        SCREEN[line] = line;
    }
}