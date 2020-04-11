// A test of boolean conditions using && || and !

void main() {
    bool_and();
    bool_or();
    bool_not();
    bool_complex();
}

void bool_and() {
    byte* const screen = $400;
    for( byte i : 0..20) {
        if( (i<10) && ((i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_or() {
    byte* const screen = $428;
    for( byte i : 0..20) {
        if( (i<10) || ((i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_not() {
    byte* const screen = $450;
    for( byte i : 0..20) {
        if( !((i<10) || (i&1)==0))  {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_complex() {
    byte* const screen = $478;
    for( byte i : 0..20) {
        if( ((i<10) && (i&1)==0) || !((i<10) || (i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}
