// Test declaring a variable as at a hard-coded address
// Changing border color using an __address variable

volatile char __address(0xd020) bgcol;

void main() {
    bgcol = 0;
}

