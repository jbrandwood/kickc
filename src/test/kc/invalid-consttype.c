void main() {
    signed byte b = -400;
    byte* SCREEN = $0400;
    *SCREEN = (byte)b;
}