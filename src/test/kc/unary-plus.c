// Test unary plus

void main() {

    char* SCREEN = (char*)0x0400;
    int* SCREEN2 = (int*)0x0428;

    char i = +3;
    SCREEN[0] = i;
    SCREEN[1] = +3;

    int j = +3;
    SCREEN2[0] = j;
    SCREEN2[1] = +3;

}