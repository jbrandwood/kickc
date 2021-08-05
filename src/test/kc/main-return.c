// Test main() with int return

int main() {
    char * SCREEN = (char*) 0x0400;
    return (int)*SCREEN;
}