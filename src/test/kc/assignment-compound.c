// Test compound assignment operators
byte ref[] = { 3, 4, 3, 18, 9, 1, 4, 2, 4, 5, 1 , 0};
byte* screen1 = (char*)$400;
byte* screen2 = screen1+40;
byte* cols = (char*)$d800;
byte GREEN = 5;
byte RED = 2;

void main() {

    byte i =0;
    byte a = 3; //3
    test(i++, a);
    a += 1; //4
    test(i++, a);
    a -= 1; //3
    test(i++, a);
    a *= 6; //18
    test(i++, a);
    a /= 2; //9
    test(i++, a);
    a %= 2; //1
    test(i++, a);
    a <<= 2; //4
    test(i++, a);
    a >>= 1; //2
    test(i++, a);
    a ^= %110; //4
    test(i++, a);
    a |= %1; //5
    test(i++, a);
    a &= %1; //1
    test(i++, a);

}

void test(byte i, byte a) {
    screen1[i] = a;
    screen2[i] = ref[i];
    if(ref[i]==a) {
        cols[i] = GREEN;
    } else {
        cols[i] = RED;
    }
}