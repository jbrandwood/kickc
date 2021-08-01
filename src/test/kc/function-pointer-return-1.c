// Tests calling functions pointer with no parameter and a return value

void main() {
    char* const SCREEN = (char*)0x400;

    char(*f)();

    char i = 0;
    for(;;) {
        ++i;
        if((i&1)==0) {
            f = &fn1;
        } else {
            f = &fn2;
        }
        char v = (*f)();
        SCREEN[0] = v;
    }
}

char fn1() {
    char* const BORDER_COLOR = (char*)0xd020;
    (*BORDER_COLOR)++;
    return *BORDER_COLOR;
}

char fn2() {
    char* const BG_COLOR = (char*)0xd021;
    (*BG_COLOR)++;
    return *BG_COLOR;
}