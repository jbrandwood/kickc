// Tests that a procedure that is never called, but requires static analysis is correctly eliminated

byte call = 0;

byte* screen = (byte*)$400;
void main() {
    screen[0] = 'a';
    if(call!=0) {
        proc();
    }
}

void proc() {
    screen[1] = 'a';
    if(screen[1]!=0) {
        screen[2] = 'a';
    }
}

