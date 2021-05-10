// Test assigning address of inline string to pointer
// The result should be an labelled .text in the ASM
// Erroneously tries to inline the string completely leading to a CompileError
void main() {
    const byte STRING[] = "camelot"z;
    byte* const PTR = (byte*)$9ffe;
    *PTR = <STRING;
    *(PTR+1)= >STRING;
    byte* ptr = (byte*) { *(PTR+1), *PTR };
    byte* const SCREEN = (byte*)$400;
    *SCREEN = *ptr;
}