byte* const BORDERCOL = $d020;
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
        byte before = *BORDERCOL;
        if(before==$ff) {
            *BORDERCOL = 2;
        } else {
            *BORDERCOL = 3;
        }
    }
}

