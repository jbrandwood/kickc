// Test function pointers with parameters
// Currently the parameter is not transferred properly

void main() {

    // A pointer to a function taking a single char param
    void(*f)(char);

    for(char i=0;i<160;i++) {
        if((i&1)==0) {
            fn3(i);
            continue;
        }
        if((i&3)==1) {
            f = &fn1;
        } else {
            f = &fn2;
        }
        (*f)(i);
    }
}

char* const SCREEN = (char*)0x400;

void fn1(char c) {
    SCREEN[c] = 'a';
}

void fn2(char d) {
    SCREEN[d] = 'b';
}

__stackcall void fn3(char e) {
    SCREEN[e] = 'c';
}