// Concatenates string constants in different ways
void main() {
    byte msg[] = "camel" "ot";
    byte* SCREEN = 0x0400;
    for( byte i=0;msg[i]!=0;i++) {
        SCREEN[i] = msg[i];
    }
}