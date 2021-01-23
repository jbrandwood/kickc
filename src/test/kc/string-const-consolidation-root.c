// Tests that multiple different identical strings are consolidated to a root variable

void main() {
    print1();
    print2();
}

char* s = "string3";
char* s1 = "string4";


void print1() {
    print("string1");
    print("string2");
    print(s);
}

void print2() {
    print("string1");
    print("string2");
    print(s1);
}

char* screen = 0x400;

void print(char* s) {
    while(*s) {
        *screen++ = *s++;
    }
}