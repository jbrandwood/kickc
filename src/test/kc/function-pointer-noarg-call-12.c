// Tests calling through pointers to non-args no-return functions

void myFunc(){
    byte* const BORDER_COLOR = $d020;
    (*BORDER_COLOR)++;
}
void myFunc2(){
    byte* const BG_COLOR = $d021;
    (*BG_COLOR)++;
}

void()* addrtable[256];

void main() {
    addrtable[0] = &myFunc;
    addrtable[1] = &myFunc2;
    void()* fn = addrtable[0];
    (*fn)();
    fn = addrtable[1];
    (*fn)();
}
