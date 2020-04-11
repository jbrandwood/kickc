// Test that modifying a nomodify-variable causes an error

void main() {
    const volatile char i = 7;
    i = 8;
}