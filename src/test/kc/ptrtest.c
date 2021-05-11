// Test all types of pointers

void main() {
  lvalue();
  rvalue();
  rvaluevar();
  lvaluevar();
}

void lvalue() {

  // A constant pointer
  byte SCREEN[1024] = (byte*)$0400;

  // LValue constant pointer dereference
  *SCREEN = 1;

  // LValue constant array constant indexing
  SCREEN[1] = 2;

  // LValue constant array variable indexing
  byte i=2;
  while(i<10) {
    SCREEN[i++] = 3;
  }
}

void rvalue() {

  // A constant pointer
  byte SCREEN[1024] = (byte*)$0400;

  // RValue constant pointer
  byte b = *SCREEN;

  // RValue constant array pointer constant index
  b = SCREEN[1];

  // RValue constant array variable index
  byte i=2;
  while(i<10) {
    b = SCREEN[i++];
  }

  byte* screen2 = (char*)$400;
  *screen2 = b;

}

void lvaluevar() {
  byte *screen = (byte*)$0400;

  // LValue Variable pointer dereference
  byte b=4;
  byte i=2;
  while(i<10) {
    *screen = b;
    screen++;
    i++;
  }

}

void rvaluevar() {
  byte *screen = (byte*)$0400;

  // RValue Variable pointer dereference
  byte b;
  byte i=2;
  while(i<10) {
    b = *screen;
    screen++;
    i++;
  }

  byte* screen2 = (char*)$400;
  *screen2 = b;

}

