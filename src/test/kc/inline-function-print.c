// TEst inlining a slightly complex print function (containing a loop)

byte* screen = (char*)$400;

void main() {
    byte* hello = "hello world!";
    print(screen, hello);
    print(screen+2*40, hello);
}

inline void print(byte* at, byte* msg) {
    byte j=0;
    for(byte i=0; msg[i]; i++) {
        at[j] = msg[i];
        j += 2;
    }
}

