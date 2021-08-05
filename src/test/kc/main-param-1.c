// Test main() with parameters

int main(int argc, char **argv) {
    char * SCREEN = (char*) 0x0400;
    SCREEN[0] = (char)argc;
    SCREEN[1] = (char) argv;
    return -1;
}