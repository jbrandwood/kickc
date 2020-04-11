// Test declarations without body

// Declaration of main-function
void main(void);

// Declaration of a sum-function
char sum(char a, char b);

char * const SCREEN = 0x0400;

// Definition of main()
void main() {
    SCREEN[0] = sum('a', 2);
    SCREEN[1] = sum('a', 12);
}

// Definition of sum()
char sum(char a, char b) {
    return a+b;
}






