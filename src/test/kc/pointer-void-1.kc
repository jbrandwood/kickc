// Test simple void pointer - void pointer function

void main() {
    dword d = 0x12345678;
    word w = 0x1234;
    byte b = 0x12;
    void* vb = &b;
    void* vw = &w;
    void* vd = &d;
    print(vb);
    print(vw);
    print(vd);
}

byte* const SCREEN = 0x0400;
byte idx = 0;

void print(void* ptr) {
    SCREEN[idx++] = *((byte*)ptr);
}