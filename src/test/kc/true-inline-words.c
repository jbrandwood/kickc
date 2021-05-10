
void main() {
    byte bs[] = { 'c', 'm' };           // constant byte array
    byte b = 4;                         // constant byte
    word w = { b, 0 };                  // constant inline word
    word w2 = (word){ 1, 1 } + w + (word){ 0, 0 };  // constant inline words inside expression
    byte* sc = (byte*)w2;               // cast to (byte*)
    *sc = bs[1];                        // In the end $501 is set to 'c'

    // Test the result
    byte* pos = (byte*)$501;
    byte* BG_COLOR = (byte*)$d021;
    if(*pos=='m') {
        *BG_COLOR = 5;
    } else {
        *BG_COLOR = 2;
    }
}

