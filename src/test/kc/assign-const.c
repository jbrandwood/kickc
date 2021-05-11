const byte prime = 7;

void main() {
    prime = 13;
    byte* screen = (byte*)$0400;
    *screen = prime;
}