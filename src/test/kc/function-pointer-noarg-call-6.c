// Tests calling into a function pointer with local variables

void fn1() {
    for(byte* screen=(byte*)$400;screen<$400+1000;screen++)
        (*screen)++;
}

void main() {
   void()* cls = &fn1;
    for(byte* cols = (char*)$d800; cols<$d800+1000;cols++) {
        (*cls)();
        (*cols)++;
    }
}



