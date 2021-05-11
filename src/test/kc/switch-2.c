// Tests simple switch()-statement - not inside a loop

void main() {
    char* SCREEN = (char*)0x0400;
    char b=0;
    char v64 = 0;
    switch(v64){
        case 0: b = 1;
    }
    SCREEN[0] = b;
}