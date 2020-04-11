// Tests what error message an accidental float gives

char* VIC_MEMORY = 0xd018;

void main() {
    *VIC_MEMORY = 0.14;
}