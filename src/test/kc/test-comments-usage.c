 // Tests that single-line comments are only included once in the output

byte* const SCREEN = (char*)$400;

 // The program entry point
void main() {
    *SCREEN = 'a';
}
