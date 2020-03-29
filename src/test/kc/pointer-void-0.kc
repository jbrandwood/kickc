// Test simple void pointer (conversion without casting)

void main() {
    byte* const SCREEN = 0x0400;
    word w = 1234;
    word* wp = &w;
    void* vp = wp;
    byte* bp = vp;
    *SCREEN = *bp;
}