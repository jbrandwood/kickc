// Tests that inline kickasm uses clause makes the compiler treat the variable in a special way
// Make sure the version of the variable transfered into the inline asm is not turned into a constant

void main() {
    char color;
    for( char i:0..2)
        color = i;
    color = 7;
    kickasm(uses color) {{ // Here 7 is turned into a constant!
        lda color
        sta $d020
    }}

}