// Tests what error message an accidental float gives

char* VICII_MEMORY = 0xd018;

void main() {
    *VICII_MEMORY = 0.14;
}