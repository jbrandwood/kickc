// Local constant strings are placed at the start of the method. This means the generated ASM jumps / calls straignt into the constant string
void main() {
    byte* screen = (byte*)$400;
    byte msg[] = "message 2 ";
    byte i=0;
    while(msg[i]) {
        screen[i++] = msg[i];
    }
}
