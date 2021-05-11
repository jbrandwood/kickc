byte b[3] = "qwe!";

void main() {
    byte* SCREEN = (char*)$400;
    SCREEN[0] = b[0];
}