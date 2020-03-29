// Tests optimizing derefs of *(ptr+b) to ptr[b]

byte msg1[] = { 'a', 'b', 'c', 'd' };
byte msg2[] = { '1', '2', '3', '4' };

void main() {
    print(msg1);
    print(msg2);
}

byte* const SCREEN = $0400;
byte idx=0;

void print(byte* m) {
    SCREEN[idx++] = *(m+2);
}