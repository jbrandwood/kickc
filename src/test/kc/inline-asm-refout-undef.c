// Reference to undefined symbol in inline asm
void main() {
    asm {
        lda qwe
    }
}