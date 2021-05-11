// Minimal struct with C-Standard behavior - member array sizeof

struct Point {
    int x;
    char initials[2];
};

char* const SCREEN = (char*)0x0400;

void main() {
    SCREEN[0] = sizeof(struct Point);
}