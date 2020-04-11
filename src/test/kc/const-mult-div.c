// Test a constant with multiplication and division

void main() {
    byte b = 6*(14/3) + 22%3;
    byte* screen = $400;
    screen[0] = b;
}