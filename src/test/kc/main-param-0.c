// Test main() with parameters

int main(int argc, char **argv) {
    char * SCREEN = (char*) 0x0400;
    return (int)*SCREEN;
}