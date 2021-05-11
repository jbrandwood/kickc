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
        bool o1 = (i<10);
        bool o2 = ((i&1)==0);
        bool o3 = o1 && o2;
        if(o3) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_or() {
    byte* const screen = (byte*)$428;
    for( byte i : 0..20) {
        bool o1 = (i<10);
        bool o2 = ((i&1)==0);
        bool o3 = o1 || o2;
        if(o3) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_not() {
    byte* const screen = (byte*)$450;
    for( byte i : 0..20) {
        bool o1 = (i<10);
        bool o2 = (i&1)==0;
        bool o3 = !( o1 || o2);
        if(o3)  {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}

void bool_complex() {
    byte* const screen = (byte*)$478;
    for( byte i : 0..20) {
        bool o1 = (i<10);
        bool o2 = (i&1)==0;
        bool o3 = (o1 && o2);
        bool o4 = !(o1 || o2);
        bool o5 = o3 || o4;
        if( o5 ) {
            screen[i] = '*';
        } else {
            screen[i] = ' ';
        }
    }
}
