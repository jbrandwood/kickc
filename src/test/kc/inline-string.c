// Inline Strings in method calls are automatically converted to local constant variables byte st[] = "..."; - generating an ASM .text).

byte msg1[] = "message 1 ";
void main() {
    byte msg2[] = "message 2 ";
    print(msg1);
    print(msg2);
    print("message 3 ");
}

byte* screen = (byte*)$400;
void print(byte* msg) {
    while(*msg) {
        *(screen++) = *(msg++);
    }
}
