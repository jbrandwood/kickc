// Test that modifying a nomodify-variable causes an error

const volatile char i = 7;

void main() {
    i = 8;
}