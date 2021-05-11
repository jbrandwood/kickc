// Test combining unwind structs with classic structs
// Function calls parameter passing

struct Point {
    char x;
    char y;
};

struct Point * const SCREEN = (struct Point *)0x0400;

void main() {
    // Initialize classic struct
    __ma struct Point p1 = { 1, 2 };
    // Pass classic struct to function taking unwound struct
    print1(p1, 0);
    // Pass classic struct to function taking classic struct
    print2(p1, 2);

    // Initialize unwound struct
    struct Point p2 = { 3, 4};
    // Pass unwound struct to function taking unwound struct
    print1(p2, 4);
    // Pass unwound struct to function taking classic struct
    print2(p2, 6);
}

// Function taking unwound struct as parameter
void print1(struct Point p, char idx) {
    // Print unwound struct
    SCREEN[idx] = p;
}

// Function taking classic struct as parameter
void print2(__ma struct Point p, char idx) {
    // Print unwound struct
    SCREEN[idx] = p;
}
