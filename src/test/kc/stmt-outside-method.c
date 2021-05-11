
byte b=12;
b=b+1;

void main() {
    byte* screen = (byte*)$400;
    *screen = b;
}