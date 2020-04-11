// Concatenates string constants in different ways
void main() {
    byte s[] = "c"
               "ame"
               "lot";
    byte* SCREEN = $400;
    for( byte i: 0..7) {
        SCREEN[i] = s[i];
    }
}