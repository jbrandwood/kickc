// Tests calling through pointers to non-args no-return functions

void myFunc(){
    byte* const BORDER_COLOR = (char*)$d020;
    (*BORDER_COLOR)++;
}
void myFunc2(){
    byte* const BG_COLOR = (char*)$d021;
    (*BG_COLOR)++;
}
void () *funcPointer;
void main() {
 funcPointer=&myFunc;
 (*funcPointer)();
 funcPointer=&myFunc2;
 (*funcPointer)();
}
