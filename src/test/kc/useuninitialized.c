// Use an uninitialized variable - should use the default value (0)!

byte b;
byte s;
byte w=2;

void main() {
   s=b+1;
   b=3;
   byte* screen = (byte*)$400;
   *screen = b;
   *(screen+1) = s;
}