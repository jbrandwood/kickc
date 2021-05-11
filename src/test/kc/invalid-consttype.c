void main() {
    signed byte b = -400;
    byte* SCREEN = (byte*)$400;
    *SCREEN = (byte)b;
}