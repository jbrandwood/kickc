// A Minimal test of boolean constants.

byte* const SCREEN = (char*)$400;

void main() {
    bool_const_if();
    bool_const_vars();
    bool_const_inline();
}

// A constant boolean inside an if()
void bool_const_if() {
    bool b = true;
    if(b) {
        SCREEN[0] = 't';
    } else {
        SCREEN[0] = 'f';
    }
}

// A bunch of constant boolean vars (used in an if)
void bool_const_vars() {
    byte a = 14;
    bool b1 = (a==15) || !(21<a);
    bool b2 = (a!=44) || (a>=-8);
    bool b = b1 && !b2 || false;
    if(b) {
        SCREEN[1] = 't';
    } else {
        SCREEN[1] = 'f';
    }
}

// A constant boolean inside an if()
void bool_const_inline() {
    byte a = 23;
    if((a!=44) || (a>=-8) && (a==15) || !(21<a)) {
        SCREEN[2] = 't';
    } else {
        SCREEN[2] = 'f';
    }
}