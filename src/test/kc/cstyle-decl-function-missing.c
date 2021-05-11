// Test function declarations
// Definition of function missing

// Declaration of a sum-function
char sum(char a, int b);

char * const SCREEN = (char*)0x0400;

// Definition of main()
void main() {
    SCREEN[0] = sum('a', 2);
    SCREEN[1] = sum('a', 12);
}





