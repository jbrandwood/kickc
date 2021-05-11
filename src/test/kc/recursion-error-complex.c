// Test that a complex recursion results in a CompileError

void main() {
    byte* screen = (char*)$400;
    byte f = fa(8);
    *screen = f;
}

// Recursive function
byte fa(byte n) {
    if(n<10) {
        return fb(n-1);
    } else {
        return fc(n+1);
    }
}

// Recursive function
byte fb(byte n) {
    if((n&1)==0) {
        return fc(n);
    } else {
        return n;
    }
}

// Recursive function
byte fc(byte n) {
    if((n&1)==0) {
        return n;
    } else {
        return fa(n/2);
    }
}

