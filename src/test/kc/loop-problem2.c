byte* const BORDER_COLOR = $d020;
byte* const SCREEN = $0400;

void main() {
    print_cls();
    mode_ctrl();
}

void print_cls() {
    for(byte* sc=SCREEN; sc!=SCREEN+1000; sc++) {
        *sc = ' ';
    }
}

void mode_ctrl() {
    while(true) {
        byte before = *BORDER_COLOR;
        if(before==$ff) {
            *BORDER_COLOR = 2;
        } else {
            *BORDER_COLOR = 3;
        }
    }
}

