// Tests that identical strings are consolidated

byte* screen = (char*)$400;

void main() {
    byte rex1[] = "rex";
    byte rex2[] = "rex";
    print(rex1);
    print(rex2);
    print("rex");
}

void print(byte* string) {
    while(*string) {
        *screen++ = *string++;
    }
}