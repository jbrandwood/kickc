// A test of boolean conditions using && || and !

void main() {
    bool_and();
    bool_or();
    bool_not();
    bool_complex();
}

void bool_and() {
    byte* const screen = (byte*)$400;
    for( byte i : 0..20) {
        if( (i<10) && ((i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_or() {
    byte* const screen = (byte*)$428;
    for( byte i : 0..20) {
        if( (i<10) || ((i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_not() {
    byte* const screen = (byte*)$450;
    for( byte i : 0..20) {
        if( !((i<10) || (i&1)==0))  {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_complex() {
    byte* const screen = (byte*)$478;
    for( byte i : 0..20) {
        if( ((i<10) && (i&1)==0) || !((i<10) || (i&1)==0) ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}
