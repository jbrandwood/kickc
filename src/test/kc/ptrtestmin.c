// Test all types of pointers

void main() {

  // A constant pointer
  byte SCREEN[1024] = $0400;

  byte b;

  // RValue constant array variable index
  byte i=2;
  while(i<10) {
    b = SCREEN[i++];
  }

  SCREEN[999] = b;

}
