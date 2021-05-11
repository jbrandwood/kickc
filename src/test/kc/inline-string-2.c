// Inline Strings in assignments

void main() {
    print_msg(1);
    print_msg(2);
}

void print_msg(byte idx) {
    byte* msg;
    if(idx==1) {
        msg = "Hello ";
    } else {
        msg = "World!";
    }
    print(msg);
}

byte* screen = (byte*)$400;
void print(byte* msg) {
    while(*msg) {
        *(screen++) = *(msg++);
    }
}
