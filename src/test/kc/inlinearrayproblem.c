// Arrays / strings allocated inline destroy functions (because they are allocated where the call enters.
// The following places the text at the start of the main-function - and JSR's straight into the text - not the code.

byte* SCREEN = (byte*)$400;
byte* SCREEN2 = (byte*)$400+$28;
void main() {
    byte txt[] = "qwe"z;
    byte data[] = { 1, 2, 3 };
    for( byte i : 0..3) {
        SCREEN[i] = txt[i];
        SCREEN2[i] = data[i];
    }
}