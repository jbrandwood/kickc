// Test address-of an array element

int VALS[] = { 1, 2, 3, 4 };

void main() {
    print(VALS);
    print(&VALS[1]);
    for(char i:2..3) {
        print(&VALS[i]);
    }

}

int* const SCREEN = (int*)0x0400;
char idx = 0;

void print(int* p) {
    SCREEN[idx++] = *p;
}


