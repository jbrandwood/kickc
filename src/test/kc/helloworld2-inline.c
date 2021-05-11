byte* screen = (char*)$400;
void main() {
    byte* hello = "hello world!";
    print2(screen, hello);
    print2(screen+80, hello);
}

inline void print2(byte* at, byte* msg) {
    byte j=0;
    for(byte i=0; msg[i]; i++) {
        at[j] = msg[i];
        j += 2;
    }
}
