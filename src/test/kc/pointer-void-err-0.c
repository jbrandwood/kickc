// Test simple void pointer - void pointer addition should fail

void main() {
   void* SCREEN = (void*)0x0400;
    byte idx = 0;
    *((byte*)SCREEN) = idx;
    SCREEN++;
    *((byte*)SCREEN) = idx;
}


