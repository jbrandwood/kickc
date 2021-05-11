// Tests simple switch()-statement - including a continue statement for the enclosing loop

void main() {
    char* SCREEN = (char*)0x0400;
    char b=0;
    char v64 = 0;
    switch(v64){
        case 0: b = 1; break;
        default:
        continue;
    }
    SCREEN[0] = b;
}